$(document).ready(function(){$("table").each(function(){"dark"==document.documentElement.getAttribute("data-theme")?$(this).addClass("table-dark"):$(this).removeClass("table-dark"),0==$(this).parents('[class*="news"]').length&&0==$(this).parents('[class*="card"]').length&&0==$(this).parents("code").length&&$(this).bootstrapTable({showHeader:!$(this).hasClass("table-hide-header"),classes:$(this).attr("class")})})});