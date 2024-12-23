// get the ninja-keys element
const ninja = document.querySelector('ninja-keys');

// add the home and posts menu items
ninja.data = [{
    id: "nav-about",
    title: "About",
    section: "Navigation",
    handler: () => {
      window.location.href = "/";
    },
  },{id: "nav-blog",
          title: "Blog",
          description: "Meng Xu&#39;s Blog Page",
          section: "Navigation",
          handler: () => {
            window.location.href = "/blog/";
          },
        },{id: "nav-research",
          title: "Research",
          description: "Meng Xu&#39;s Research Page",
          section: "Navigation",
          handler: () => {
            window.location.href = "/research/";
          },
        },{id: "nav-teaching",
          title: "Teaching",
          description: "Meng Xu&#39;s Teaching Page",
          section: "Navigation",
          handler: () => {
            window.location.href = "/teaching/";
          },
        },{id: "nav-cv",
          title: "CV",
          description: "Meng Xu&#39;s CV Page",
          section: "Navigation",
          handler: () => {
            window.location.href = "/cv/";
          },
        },{id: "post-corporate-governance-in-the-sun-my-icgs-adventure-at-asu",
      
        title: "Corporate Governance in the Sun: My ICGS Adventure at ASU",
      
      description: "Meng Xu&#39;s ICGS adventure at ASU",
      section: "Posts",
      handler: () => {
        
          window.location.href = "/blog/2024/corporate_governance_in_the_sun_my_icgs_adventure_at_asu/";
        
      },
    },{id: "post-my-first-year-as-a-phd-student",
      
        title: "My First Year as a PhD Student",
      
      description: "Meng Xu&#39;s first year as a PhD student",
      section: "Posts",
      handler: () => {
        
          window.location.href = "/blog/2024/my_first_year_as_a_phd_student/";
        
      },
    },{id: "post-reflections-on-my-uga-management-phd-application",
      
        title: "Reflections on My UGA Management PhD Application",
      
      description: "Meng Xu&#39;s reflections of UGA management PhD application",
      section: "Posts",
      handler: () => {
        
          window.location.href = "/blog/2023/reflections_on_my_uga_management_phd_application/";
        
      },
    },{id: "post-how-to-access-paywalled-research-papers-for-free",
      
        title: "How to Access Paywalled Research Papers For Free",
      
      description: "Meng Xu&#39;s solution of accessing paywalled research papers",
      section: "Posts",
      handler: () => {
        
          window.location.href = "/blog/2023/how_to_access_paywalled_research_papers_for_free/";
        
      },
    },{id: "post-my-tips-for-beginners-as-a-beginner-how-to-read-a-paper",
      
        title: "My Tips for Beginners as a Beginner - How to Read a Paper...",
      
      description: "Meng Xu&#39;s tips of reading a paper",
      section: "Posts",
      handler: () => {
        
          window.location.href = "/blog/2022/my_tips_for_beginners_as_a_beginner_how_to_read_a_paper/";
        
      },
    },{id: "post-why-i-blog-and-why-you-should-too",
      
        title: "Why I Blog and Why You Should too",
      
      description: "Meng Xu&#39;s reason of blogging",
      section: "Posts",
      handler: () => {
        
          window.location.href = "/blog/2022/why_i_blog_and_why_you_should_too/";
        
      },
    },{id: "news-i-officially-started-my-phd-application",
          title: 'I officially started my PhD application!',
          description: "Meng Xu&#39;s PhD application announcement",
          section: "News",},{id: "news-i-am-accepted-into-the-management-ph-d-program-at-uga",
          title: 'I am accepted into the Management Ph.D Program at UGA!',
          description: "Meng Xu&#39;s PhD admission announcement",
          section: "News",},{id: "news-i-am-attending-my-first-aom-conference-in-boston",
          title: 'I am attending my first AOM conference in Boston!',
          description: "Meng Xu&#39;s first AOM conference attendance",
          section: "News",},{id: "news-first-day-of-the-phd-program",
          title: 'First day of the PhD program!',
          description: "Meng Xu&#39;s first day of the PhD program",
          section: "News",},{id: "teaching-information-systems-and-digital-transformation",
          title: 'Information Systems and Digital Transformation',
          description: "Information Systems and Digital Transformation course at Georgia Institute of Technology",
          section: "Teaching",handler: () => {
              window.location.href = "/teaching/information_systems_and_digital_transformation/";
            },},{id: "teaching-principles-of-management",
          title: 'Principles of Management',
          description: "Principles of Management course at the University of Georgia",
          section: "Teaching",handler: () => {
              window.location.href = "/teaching/principles_of_management/";
            },},{id: "teaching-visual-reporting-and-communication",
          title: 'Visual Reporting and Communication',
          description: "Visual Reporting and Communication course at Mercer University",
          section: "Teaching",handler: () => {
              window.location.href = "/teaching/visual_reporting_and_communication/";
            },},{
        id: 'social-email',
        title: 'Email',
        section: 'Socials',
        handler: () => {
          window.open("mailto:%6D%65%6E%67%78%75@%75%67%61.%65%64%75", "_blank");
        },
      },{
        id: 'social-linkedin',
        title: 'LinkedIn',
        section: 'Socials',
        handler: () => {
          window.open("https://www.linkedin.com/in/mxu", "_blank");
        },
      },{
        id: 'social-rss',
        title: 'RSS Feed',
        section: 'Socials',
        handler: () => {
          window.open("/feed.xml", "_blank");
        },
      },{
        id: 'social-school',
        title: 'School',
        section: 'Socials',
        handler: () => {
          window.open("https://www.terry.uga.edu/directory/meng-xu/", "_blank");
        },
      },{
      id: 'light-theme',
      title: 'Change Theme to Light',
      description: 'Change the theme of the site to Light',
      section: 'Theme',
      handler: () => {
        setThemeSetting("light");
      },
    },
    {
      id: 'dark-theme',
      title: 'Change Theme to Dark',
      description: 'Change the theme of the site to Dark',
      section: 'Theme',
      handler: () => {
        setThemeSetting("dark");
      },
    },
    {
      id: 'system-theme',
      title: 'Use System Default Theme',
      description: 'Change the theme of the site to System Default',
      section: 'Theme',
      handler: () => {
        setThemeSetting("system");
      },
    },];
