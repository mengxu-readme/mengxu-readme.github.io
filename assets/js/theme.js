let toggleThemeSetting=()=>{let e=determineThemeSetting();setThemeSetting("system"==e?"light":"light"==e?"dark":"system")},setThemeSetting=e=>{localStorage.setItem("theme",e),document.documentElement.setAttribute("data-theme-setting",e),applyTheme()},applyTheme=()=>{let e=determineComputedTheme();setHighlight(e),setGiscusTheme(e),setSearchTheme(e),"undefined"!=typeof mermaid&&setMermaidTheme(e),"undefined"!=typeof Diff2HtmlUI&&setDiff2htmlTheme(e),"undefined"!=typeof echarts&&setEchartsTheme(e),"undefined"!=typeof Plotly&&setPlotlyTheme(e),"undefined"!=typeof vegaEmbed&&setVegaLiteTheme(e),document.documentElement.setAttribute("data-theme",e);let t=document.getElementsByTagName("table");for(let o=0;o<t.length;o++)"dark"==e?t[o].classList.add("table-dark"):t[o].classList.remove("table-dark");let o=document.getElementsByClassName("jupyter-notebook-iframe-container");for(let t=0;t<o.length;t++){let r=o[t].getElementsByTagName("iframe")[0].contentWindow.document.body;"dark"==e?(r.setAttribute("data-jp-theme-light","false"),r.setAttribute("data-jp-theme-name","JupyterLab Dark")):(r.setAttribute("data-jp-theme-light","true"),r.setAttribute("data-jp-theme-name","JupyterLab Light"))}"undefined"!=typeof medium_zoom&&medium_zoom.update({background:getComputedStyle(document.documentElement).getPropertyValue("--global-bg-color")+"ee"})},setHighlight=e=>{"dark"==e?(document.getElementById("highlight_theme_light").media="none",document.getElementById("highlight_theme_dark").media=""):(document.getElementById("highlight_theme_dark").media="none",document.getElementById("highlight_theme_light").media="")},setGiscusTheme=e=>{function t(e){const t=document.querySelector("iframe.giscus-frame");t&&t.contentWindow.postMessage({giscus:e},"https://giscus.app")}t({setConfig:{theme:e}})},addMermaidZoom=(e,t)=>{d3.selectAll(".mermaid svg").each((function(){var e=d3.select(this);e.html("<g>"+e.html()+"</g>");var t=e.select("g"),o=d3.zoom().on("zoom",(function(e){t.attr("transform",e.transform)}));e.call(o)})),t.disconnect()},setMermaidTheme=e=>{"light"==e&&(e="default"),document.querySelectorAll(".mermaid").forEach((e=>{let t=e.previousSibling.childNodes[0].innerHTML;e.removeAttribute("data-processed"),e.innerHTML=t})),mermaid.initialize({theme:e}),window.mermaid.init(void 0,document.querySelectorAll(".mermaid"));const t=document.querySelector(".mermaid svg");if(null!==t){const e={childList:!0};new MutationObserver(addMermaidZoom).observe(t,e)}},setDiff2htmlTheme=e=>{document.querySelectorAll(".diff2html").forEach((t=>{let o=t.previousSibling.childNodes[0].innerHTML;t.innerHTML="";new Diff2HtmlUI(t,o,{colorScheme:e,drawFileList:!0,highlight:!0,matching:"lines"}).draw()}))},setEchartsTheme=e=>{document.querySelectorAll(".echarts").forEach((t=>{let o=t.previousSibling.childNodes[0].innerHTML;if(echarts.dispose(t),"dark"===e)var r=echarts.init(t,"dark-fresh-cut");else r=echarts.init(t);r.setOption(JSON.parse(o))}))},setPlotlyTheme=e=>{document.querySelectorAll(".js-plotly-plot").forEach((t=>{let o=JSON.parse(t.previousSibling.childNodes[0].innerHTML);if("dark"===e){const e={layout:{autotypenumbers:"strict",colorway:["#636efa","#EF553B","#00cc96","#ab63fa","#FFA15A","#19d3f3","#FF6692","#B6E880","#FF97FF","#FECB52"],font:{color:"#f2f5fa"},hovermode:"closest",hoverlabel:{align:"left"},paper_bgcolor:"rgb(17,17,17)",plot_bgcolor:"rgb(17,17,17)",polar:{bgcolor:"rgb(17,17,17)",angularaxis:{gridcolor:"#506784",linecolor:"#506784",ticks:""},radialaxis:{gridcolor:"#506784",linecolor:"#506784",ticks:""}},ternary:{bgcolor:"rgb(17,17,17)",aaxis:{gridcolor:"#506784",linecolor:"#506784",ticks:""},baxis:{gridcolor:"#506784",linecolor:"#506784",ticks:""},caxis:{gridcolor:"#506784",linecolor:"#506784",ticks:""}},coloraxis:{colorbar:{outlinewidth:0,ticks:""}},colorscale:{sequential:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]],sequentialminus:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]],diverging:[[0,"#8e0152"],[.1,"#c51b7d"],[.2,"#de77ae"],[.3,"#f1b6da"],[.4,"#fde0ef"],[.5,"#f7f7f7"],[.6,"#e6f5d0"],[.7,"#b8e186"],[.8,"#7fbc41"],[.9,"#4d9221"],[1,"#276419"]]},xaxis:{gridcolor:"#283442",linecolor:"#506784",ticks:"",title:{standoff:15},zerolinecolor:"#283442",automargin:!0,zerolinewidth:2},yaxis:{gridcolor:"#283442",linecolor:"#506784",ticks:"",title:{standoff:15},zerolinecolor:"#283442",automargin:!0,zerolinewidth:2},scene:{xaxis:{backgroundcolor:"rgb(17,17,17)",gridcolor:"#506784",linecolor:"#506784",showbackground:!0,ticks:"",zerolinecolor:"#C8D4E3",gridwidth:2},yaxis:{backgroundcolor:"rgb(17,17,17)",gridcolor:"#506784",linecolor:"#506784",showbackground:!0,ticks:"",zerolinecolor:"#C8D4E3",gridwidth:2},zaxis:{backgroundcolor:"rgb(17,17,17)",gridcolor:"#506784",linecolor:"#506784",showbackground:!0,ticks:"",zerolinecolor:"#C8D4E3",gridwidth:2}},shapedefaults:{line:{color:"#f2f5fa"}},annotationdefaults:{arrowcolor:"#f2f5fa",arrowhead:0,arrowwidth:1},geo:{bgcolor:"rgb(17,17,17)",landcolor:"rgb(17,17,17)",subunitcolor:"#506784",showland:!0,showlakes:!0,lakecolor:"rgb(17,17,17)"},title:{x:.05},updatemenudefaults:{bgcolor:"#506784",borderwidth:0},sliderdefaults:{bgcolor:"#C8D4E3",borderwidth:1,bordercolor:"rgb(17,17,17)",tickwidth:0},mapbox:{style:"dark"}},data:{histogram2dcontour:[{type:"histogram2dcontour",colorbar:{outlinewidth:0,ticks:""},colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],choropleth:[{type:"choropleth",colorbar:{outlinewidth:0,ticks:""}}],histogram2d:[{type:"histogram2d",colorbar:{outlinewidth:0,ticks:""},colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],heatmap:[{type:"heatmap",colorbar:{outlinewidth:0,ticks:""},colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],contourcarpet:[{type:"contourcarpet",colorbar:{outlinewidth:0,ticks:""}}],contour:[{type:"contour",colorbar:{outlinewidth:0,ticks:""},colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],surface:[{type:"surface",colorbar:{outlinewidth:0,ticks:""},colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],mesh3d:[{type:"mesh3d",colorbar:{outlinewidth:0,ticks:""}}],scatter:[{marker:{line:{color:"#283442"}},type:"scatter"}],parcoords:[{type:"parcoords",line:{colorbar:{outlinewidth:0,ticks:""}}}],scatterpolargl:[{type:"scatterpolargl",marker:{colorbar:{outlinewidth:0,ticks:""}}}],bar:[{error_x:{color:"#f2f5fa"},error_y:{color:"#f2f5fa"},marker:{line:{color:"rgb(17,17,17)",width:.5},pattern:{fillmode:"overlay",size:10,solidity:.2}},type:"bar"}],scattergeo:[{type:"scattergeo",marker:{colorbar:{outlinewidth:0,ticks:""}}}],scatterpolar:[{type:"scatterpolar",marker:{colorbar:{outlinewidth:0,ticks:""}}}],histogram:[{marker:{pattern:{fillmode:"overlay",size:10,solidity:.2}},type:"histogram"}],scattergl:[{marker:{line:{color:"#283442"}},type:"scattergl"}],scatter3d:[{type:"scatter3d",line:{colorbar:{outlinewidth:0,ticks:""}},marker:{colorbar:{outlinewidth:0,ticks:""}}}],scattermap:[{type:"scattermap",marker:{colorbar:{outlinewidth:0,ticks:""}}}],scattermapbox:[{type:"scattermapbox",marker:{colorbar:{outlinewidth:0,ticks:""}}}],scatterternary:[{type:"scatterternary",marker:{colorbar:{outlinewidth:0,ticks:""}}}],scattercarpet:[{type:"scattercarpet",marker:{colorbar:{outlinewidth:0,ticks:""}}}],carpet:[{aaxis:{endlinecolor:"#A2B1C6",gridcolor:"#506784",linecolor:"#506784",minorgridcolor:"#506784",startlinecolor:"#A2B1C6"},baxis:{endlinecolor:"#A2B1C6",gridcolor:"#506784",linecolor:"#506784",minorgridcolor:"#506784",startlinecolor:"#A2B1C6"},type:"carpet"}],table:[{cells:{fill:{color:"#506784"},line:{color:"rgb(17,17,17)"}},header:{fill:{color:"#2a3f5f"},line:{color:"rgb(17,17,17)"}},type:"table"}],barpolar:[{marker:{line:{color:"rgb(17,17,17)",width:.5},pattern:{fillmode:"overlay",size:10,solidity:.2}},type:"barpolar"}],pie:[{automargin:!0,type:"pie"}]}};o.layout?o.layout.template?o.layout.template={...e,...o.layout.template}:o.layout.template=e:o.layout={template:e}}else{const e={layout:{autotypenumbers:"strict",colorway:["#636efa","#EF553B","#00cc96","#ab63fa","#FFA15A","#19d3f3","#FF6692","#B6E880","#FF97FF","#FECB52"],font:{color:"#2a3f5f"},hovermode:"closest",hoverlabel:{align:"left"},paper_bgcolor:"white",plot_bgcolor:"white",polar:{bgcolor:"white",angularaxis:{gridcolor:"#EBF0F8",linecolor:"#EBF0F8",ticks:""},radialaxis:{gridcolor:"#EBF0F8",linecolor:"#EBF0F8",ticks:""}},ternary:{bgcolor:"white",aaxis:{gridcolor:"#DFE8F3",linecolor:"#A2B1C6",ticks:""},baxis:{gridcolor:"#DFE8F3",linecolor:"#A2B1C6",ticks:""},caxis:{gridcolor:"#DFE8F3",linecolor:"#A2B1C6",ticks:""}},coloraxis:{colorbar:{outlinewidth:0,ticks:""}},colorscale:{sequential:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]],sequentialminus:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]],diverging:[[0,"#8e0152"],[.1,"#c51b7d"],[.2,"#de77ae"],[.3,"#f1b6da"],[.4,"#fde0ef"],[.5,"#f7f7f7"],[.6,"#e6f5d0"],[.7,"#b8e186"],[.8,"#7fbc41"],[.9,"#4d9221"],[1,"#276419"]]},xaxis:{gridcolor:"#EBF0F8",linecolor:"#EBF0F8",ticks:"",title:{standoff:15},zerolinecolor:"#EBF0F8",automargin:!0,zerolinewidth:2},yaxis:{gridcolor:"#EBF0F8",linecolor:"#EBF0F8",ticks:"",title:{standoff:15},zerolinecolor:"#EBF0F8",automargin:!0,zerolinewidth:2},scene:{xaxis:{backgroundcolor:"white",gridcolor:"#DFE8F3",linecolor:"#EBF0F8",showbackground:!0,ticks:"",zerolinecolor:"#EBF0F8",gridwidth:2},yaxis:{backgroundcolor:"white",gridcolor:"#DFE8F3",linecolor:"#EBF0F8",showbackground:!0,ticks:"",zerolinecolor:"#EBF0F8",gridwidth:2},zaxis:{backgroundcolor:"white",gridcolor:"#DFE8F3",linecolor:"#EBF0F8",showbackground:!0,ticks:"",zerolinecolor:"#EBF0F8",gridwidth:2}},shapedefaults:{line:{color:"#2a3f5f"}},annotationdefaults:{arrowcolor:"#2a3f5f",arrowhead:0,arrowwidth:1},geo:{bgcolor:"white",landcolor:"white",subunitcolor:"#C8D4E3",showland:!0,showlakes:!0,lakecolor:"white"},title:{x:.05},mapbox:{style:"light"}},data:{histogram2dcontour:[{type:"histogram2dcontour",colorbar:{outlinewidth:0,ticks:""},colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],choropleth:[{type:"choropleth",colorbar:{outlinewidth:0,ticks:""}}],histogram2d:[{type:"histogram2d",colorbar:{outlinewidth:0,ticks:""},colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],heatmap:[{type:"heatmap",colorbar:{outlinewidth:0,ticks:""},colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],contourcarpet:[{type:"contourcarpet",colorbar:{outlinewidth:0,ticks:""}}],contour:[{type:"contour",colorbar:{outlinewidth:0,ticks:""},colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],surface:[{type:"surface",colorbar:{outlinewidth:0,ticks:""},colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],mesh3d:[{type:"mesh3d",colorbar:{outlinewidth:0,ticks:""}}],scatter:[{fillpattern:{fillmode:"overlay",size:10,solidity:.2},type:"scatter"}],parcoords:[{type:"parcoords",line:{colorbar:{outlinewidth:0,ticks:""}}}],scatterpolargl:[{type:"scatterpolargl",marker:{colorbar:{outlinewidth:0,ticks:""}}}],bar:[{error_x:{color:"#2a3f5f"},error_y:{color:"#2a3f5f"},marker:{line:{color:"white",width:.5},pattern:{fillmode:"overlay",size:10,solidity:.2}},type:"bar"}],scattergeo:[{type:"scattergeo",marker:{colorbar:{outlinewidth:0,ticks:""}}}],scatterpolar:[{type:"scatterpolar",marker:{colorbar:{outlinewidth:0,ticks:""}}}],histogram:[{marker:{pattern:{fillmode:"overlay",size:10,solidity:.2}},type:"histogram"}],scattergl:[{type:"scattergl",marker:{colorbar:{outlinewidth:0,ticks:""}}}],scatter3d:[{type:"scatter3d",line:{colorbar:{outlinewidth:0,ticks:""}},marker:{colorbar:{outlinewidth:0,ticks:""}}}],scattermap:[{type:"scattermap",marker:{colorbar:{outlinewidth:0,ticks:""}}}],scattermapbox:[{type:"scattermapbox",marker:{colorbar:{outlinewidth:0,ticks:""}}}],scatterternary:[{type:"scatterternary",marker:{colorbar:{outlinewidth:0,ticks:""}}}],scattercarpet:[{type:"scattercarpet",marker:{colorbar:{outlinewidth:0,ticks:""}}}],carpet:[{aaxis:{endlinecolor:"#2a3f5f",gridcolor:"#C8D4E3",linecolor:"#C8D4E3",minorgridcolor:"#C8D4E3",startlinecolor:"#2a3f5f"},baxis:{endlinecolor:"#2a3f5f",gridcolor:"#C8D4E3",linecolor:"#C8D4E3",minorgridcolor:"#C8D4E3",startlinecolor:"#2a3f5f"},type:"carpet"}],table:[{cells:{fill:{color:"#EBF0F8"},line:{color:"white"}},header:{fill:{color:"#C8D4E3"},line:{color:"white"}},type:"table"}],barpolar:[{marker:{line:{color:"white",width:.5},pattern:{fillmode:"overlay",size:10,solidity:.2}},type:"barpolar"}],pie:[{automargin:!0,type:"pie"}]}};o.layout?o.layout.template?o.layout.template={...e,...o.layout.template}:o.layout.template=e:o.layout={template:e}}Plotly.relayout(t,o.layout)}))},setVegaLiteTheme=e=>{document.querySelectorAll(".vega-lite").forEach((t=>{let o=t.previousSibling.childNodes[0].innerHTML;t.innerHTML="","dark"===e?vegaEmbed(t,JSON.parse(o),{theme:"dark"}):vegaEmbed(t,JSON.parse(o))}))},setSearchTheme=e=>{const t=document.querySelector("ninja-keys");t&&("dark"===e?t.classList.add("dark"):t.classList.remove("dark"))},transTheme=()=>{document.documentElement.classList.add("transition"),window.setTimeout((()=>{document.documentElement.classList.remove("transition")}),500)},determineThemeSetting=()=>{let e=localStorage.getItem("theme");return"dark"!=e&&"light"!=e&&"system"!=e&&(e="system"),e},determineComputedTheme=()=>{let e=determineThemeSetting();if("system"==e){const e=window.matchMedia;return e&&e("(prefers-color-scheme: dark)").matches?"dark":"light"}return e},initTheme=()=>{let e=determineThemeSetting();setThemeSetting(e),document.addEventListener("DOMContentLoaded",(function(){document.getElementById("light-toggle").addEventListener("click",(function(){toggleThemeSetting()}))})),window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change",(({matches:e})=>{applyTheme()}))};