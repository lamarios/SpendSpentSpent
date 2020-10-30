
<#macro header title>
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
    </style>
</head>
<body>
<h1>SpendSpentSpent</h1>
<h2>${title}</h2>
<div class="content">
    </#macro>

    <#macro footer >
</div>
<div class="footer">
    Email sent from SpentSpentSpent.
</div>
</body>
</html>
</#macro>
