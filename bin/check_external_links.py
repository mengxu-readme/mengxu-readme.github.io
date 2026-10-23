import argparse
import glob
import os
import sys
from urllib.parse import urlparse

from bs4 import BeautifulSoup
from playwright.sync_api import Error as PlaywrightError
from playwright.sync_api import TimeoutError as PlaywrightTimeoutError
from playwright.sync_api import sync_playwright


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--site-dir", default="_site")
    parser.add_argument("--ignore-files", default="")
    parser.add_argument("--ignore-urls", default="")
    args = parser.parse_args()

    ignore_files = [
        item.strip()
        for item in args.ignore_files.split(",")
        if item.strip()
    ]
    ignore_urls = [
        item.strip()
        for item in args.ignore_urls.split(",")
        if item.strip()
    ]

    links = set()

    for file_path in glob.glob(
        os.path.join(args.site_dir, "**", "*.html"),
        recursive=True,
    ):
        if file_path in ignore_files:
            continue

        with open(file_path, "r", encoding="utf-8") as f:
            soup = BeautifulSoup(f, "html.parser")

        for tag, attr in (
            ("a", "href"),
            ("script", "src"),
            ("link", "href"),
            ("img", "src"),
        ):
            for element in soup.find_all(tag, **{attr: True}):
                url = element.get(attr)

                if not url or url in ignore_urls:
                    continue

                parsed = urlparse(url)
                if parsed.scheme in ("http", "https") and parsed.netloc:
                    links.add(url)

    print(f"Checking {len(links)} external links")

    failed_links = {}

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(
            user_agent=(
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                "AppleWebKit/537.36 (KHTML, like Gecko) "
                "Chrome/120.0.0.0 Safari/537.36"
            )
        )

        for link in sorted(links):
            try:
                response = page.goto(link, timeout=15000)

            except PlaywrightTimeoutError as e:
                failed_links[link] = "timeout"
                print(f"Timeout for {link}: {e}")
                continue

            except PlaywrightError as e:
                failed_links[link] = "navigation error"
                print(f"Navigation error for {link}: {e}")
                continue

            if response is None:
                failed_links[link] = "no response"
                print(f"No response for {link}")
                continue

            chain = []
            request = response.request

            while request is not None:
                chain.append(request)
                request = request.redirected_from

            chain.reverse()

            redirect_messages = []
            request_errors = []

            for req in chain:
                resp = req.response()

                if resp is None:
                    continue

                print(f"Received {resp.status} for {req.url}")

                if 300 <= resp.status < 400:
                    location = resp.headers.get(
                        "location", "(unknown)"
                    )
                    redirect_messages.append(
                        f"HTTP {resp.status}: {req.url} "
                        f"redirects to {location}"
                    )

                elif resp.status < 200 or resp.status >= 400:
                    request_errors.append(
                        f"HTTP {resp.status} at {req.url}"
                    )

            if redirect_messages:
                failed_links[link] = "; ".join(redirect_messages)

            if request_errors:
                message = "; ".join(request_errors)
                if link in failed_links:
                    failed_links[link] += f"; {message}"
                else:
                    failed_links[link] = message

            print(
                f"Final response: {response.status} "
                f"at {response.url}"
            )

        browser.close()

    print(
        f"Finished checking external links. "
        f"{len(failed_links)} failed."
    )

    if failed_links:
        for link, message in sorted(failed_links.items()):
            print(
                f"External link {link} failed ({message})",
                file=sys.stderr,
            )
        sys.exit(1)


if __name__ == "__main__":
    main()
