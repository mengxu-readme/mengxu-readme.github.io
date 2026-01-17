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

    ignore_files = [ignore_file.strip() for ignore_file in args.ignore_files.split(",") if ignore_file.strip()]
    ignore_urls = [ignore_url.strip() for ignore_url in args.ignore_urls.split(",") if ignore_url.strip()]

    links = set()
    for file_path in glob.glob(os.path.join(args.site_dir, "**/*.html"), recursive=True):
        if file_path in ignore_files:
            continue
        with open(file_path, "r", encoding="utf-8") as f:
            soup = BeautifulSoup(f, "html.parser")

            for a_tag in soup.find_all("a", href=True):
                href = a_tag["href"]
                if not href or href in ignore_urls:
                    continue
                parsed = urlparse(href)
                if parsed.scheme in ("http", "https") and parsed.netloc:
                    links.add(href)

            for script_tag in soup.find_all("script", src=True):
                src = script_tag.get("src")
                if not src or src in ignore_urls:
                    continue
                parsed = urlparse(src)
                if parsed.scheme in ("http", "https") and parsed.netloc:
                    links.add(src)

            for link_tag in soup.find_all("link", href=True):
                href = link_tag.get("href")
                if not href or href in ignore_urls:
                    continue
                parsed = urlparse(href)
                if parsed.scheme in ("http", "https") and parsed.netloc:
                    links.add(href)

            for img_tag in soup.find_all("img", src=True):
                src = img_tag.get("src")
                if not src or src in ignore_urls:
                    continue
                parsed = urlparse(src)
                if parsed.scheme in ("http", "https") and parsed.netloc:
                    links.add(src)

    print(f"Checking {len(links)} external links")

    failed_links = dict()
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(
            user_agent=(
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                "AppleWebKit/537.36 (KHTML, like Gecko) "
                "Chrome/120.0.0.0 Safari/537.36"
            )
        )

        for link in links:
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

            request = response.request
            while request.redirected_from is not None:
                request = request.redirected_from
            original_response = request.response()
            original_status = original_response.status

            print(f"Received {original_status} for {link}")
            if response.url != link:
                failed_links[link] = f"redirected to {response.url}"
            if original_status < 200 or original_status >= 300:
                failed_links[link] = f"status code {original_status}"

        browser.close()

    print(f"Finished checking external links. {len(failed_links)} failed.")

    if failed_links:
        for link, message in failed_links.items():
            print(f"External link {link} failed ({message})", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
