const ninja=document.querySelector("ninja-keys");ninja.data=[{id:"nav-about",title:"About",section:"Navigation",handler:()=>{window.location.href="/"}},{id:"nav-blog",title:"Blog",description:"Meng Xu&#39;s Blog Page",section:"Navigation",handler:()=>{window.location.href="/blog/"}},{id:"nav-research",title:"Research",description:"Meng Xu&#39;s Research Page",section:"Navigation",handler:()=>{window.location.href="/research/"}},{id:"nav-teaching",title:"Teaching",description:"Meng Xu&#39;s Teaching Page",section:"Navigation",handler:()=>{window.location.href="/teaching/"}},{id:"nav-cv",title:"CV",description:"Meng Xu&#39;s CV Page",section:"Navigation",handler:()=>{window.location.href="/cv/"}},{id:"post-reflections-on-my-uga-management-phd-application",title:"Reflections on My UGA Management PhD Application",description:"Meng Xu&#39;s reflections of UGA management PhD application",section:"Posts",handler:()=>{window.location.href="/blog/2023/reflections_on_my_uga_management_phd_application/"}},{id:"post-how-to-access-paywalled-research-papers-for-free",title:"How to Access Paywalled Research Papers For Free",description:"Meng Xu&#39;s solution of accessing paywalled research papers",section:"Posts",handler:()=>{window.location.href="/blog/2023/how_to_access_paywalled_research_papers_for_free/"}},{id:"post-my-tips-for-beginners-as-a-beginner-how-to-read-a-paper",title:"My Tips for Beginners as a Beginner - How to Read a Paper",description:"Meng Xu&#39;s tips of reading a paper",section:"Posts",handler:()=>{window.location.href="/blog/2022/my_tips_for_beginners_as_a_beginner_how_to_read_a_paper/"}},{id:"post-why-i-blog-and-why-you-should-too",title:"Why I Blog and Why You Should too",description:"Meng Xu&#39;s reason of blogging",section:"Posts",handler:()=>{window.location.href="/blog/2022/why_i_blog_and_why_you_should_too/"}},{id:"teaching-information-systems-and-digital-transformation",title:"Information Systems and Digital Transformation",description:"Information Systems and Digital Transformation course at Georgia Institute of Technology",section:"Teaching",handler:()=>{window.location.href="/teaching/information_systems_and_digital_transformation/"}},{id:"teaching-principles-of-management",title:"Principles of Management",description:"Principles of Management course at the University of Georgia",section:"Teaching",handler:()=>{window.location.href="/teaching/principles_of_management/"}},{id:"teaching-visual-reporting-and-communication",title:"Visual Reporting and Communication",description:"Visual Reporting and Communication course at Mercer University",section:"Teaching",handler:()=>{window.location.href="/teaching/visual_reporting_and_communication/"}},{id:"socials-email",title:"Send Email",section:"Socials",handler:()=>{window.open("mailto:%6D%65%6E%67%78%75@%75%67%61.%65%64%75","_blank")}},{id:"socials-linkedin",title:"LinkedIn",section:"Socials",handler:()=>{window.open("https://www.linkedin.com/in/mxu","_blank")}},{id:"socials-school",title:"School",section:"Socials",handler:()=>{window.open("https://www.terry.uga.edu/directory/meng-xu/","_blank")}},{id:"socials-rss",title:"RSS Feed",section:"Socials",handler:()=>{window.open("/feed.xml","_blank")}},{id:"light-theme",title:"Change theme to light",description:"Change the theme of the site to Light",section:"Theme",handler:()=>{setThemeSetting("light")}},{id:"dark-theme",title:"Change theme to dark",description:"Change the theme of the site to Dark",section:"Theme",handler:()=>{setThemeSetting("dark")}},{id:"system-theme",title:"Use system default theme",description:"Change the theme of the site to System Default",section:"Theme",handler:()=>{setThemeSetting("system")}}];