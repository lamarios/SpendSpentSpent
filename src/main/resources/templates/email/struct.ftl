
<#macro header title addCategoryIcons=false>
    <!DOCTYPE html>
<html>
<head>
    <title>[SpendSpentSpent] ${title}</title>
    <style>
        h1 {
            color: #2196f3;
        }

        .footer {
            border-top: 1px solid #ccc;
            margin: 10px;
            font-size: 12px;
        }

        .content {
            border-radius: 5px;
            background-color: #eee;
            padding: 30px;
        }

        ul {
            list-style: none;
        }

        .cat {
            display: inline-block;
            width: 30px;
            font-size: 20px;
            color: #2196f3;
            text-align: center;
        }

        .amount {
            font-size: 20px;
        }
    </style>
    <#if addCategoryIcons>
        <link href="https://d39m8zk9id2epd.cloudfront.net/style.css" rel="stylesheet">
    </#if>
</head>
<body>
<h1>SpendSpentSpent</h1>
<h2>${title}</h2>
<div class="content">
    </#macro>

    <#macro footer footerUrl>
</div>
<div class="footer">
    Email sent from SpentSpentSpent hosted on <a href="${footerUrl}">${footerUrl}</a>.
</div>
</body>
</html>
</#macro>
