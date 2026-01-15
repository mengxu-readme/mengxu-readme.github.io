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
        },{id: "post-i-passed-comps-reflections-struggles-and-tips-for-future-students",
        
          title: "I Passed Comps! Reflections, Struggles, and Tips for Future Students",
        
        description: "Meng Xu Passed Comps",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/i_passed_comps_reflections_struggles_and_tips_for_future_students/";
          
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
      },{id: "news-i-officially-started-my-phd-application",
          title: 'I officially started my PhD application!',
          description: "Meng Xu&#39;s PhD application announcement",
          section: "News",},{id: "news-i-am-accepted-into-the-management-ph-d-program-at-uga",
          title: 'I am accepted into the Management Ph.D Program at UGA!',
          description: "Meng Xu&#39;s PhD admission announcement",
          section: "News",},{id: "news-first-day-of-the-phd-program",
          title: 'First day of the PhD program!',
          description: "Meng Xu&#39;s first day of the PhD program",
          section: "News",},{id: "news-my-first-conference-presentation",
          title: 'My first conference presentation!',
          description: "Meng Xu&#39;s first conference presentation",
          section: "News",},{id: "news-i-passed-comps",
          title: 'I passed comps!',
          description: "Meng Xu&#39;s comps",
          section: "News",},{id: "teaching-information-systems-and-digital-transformation",
          title: 'Information Systems and Digital Transformation',
          description: "Information Systems and Digital Transformation course at Georgia Institute of Technology",
          section: "Teaching",handler: () => {
              window.location.href = "/teaching/information_systems_and_digital_transformation/";
            },},{id: "teaching-international-strategic-management",
          title: 'International Strategic Management',
          description: "International Strategic Management course at the University of Georgia",
          section: "Teaching",handler: () => {
              window.location.href = "/teaching/international_strategic_management/";
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
        id: 'social-cv',
        title: 'CV',
        section: 'Socials',
        handler: () => {
          window.open("/assets/pdf/cv/Meng_Xu_CV.pdf", "_blank");
        },
      },{
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
        id: 'social-scholar',
        title: 'Google Scholar',
        section: 'Socials',
        handler: () => {
          window.open("https://scholar.google.com/citations?user=GXFOOWUAAAAJ", "_blank");
        },
      },{
        id: 'social-work',
        title: 'Work',
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
