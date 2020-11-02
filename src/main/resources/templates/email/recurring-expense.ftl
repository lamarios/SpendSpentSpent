<#import "./struct.ftl" as struct>

<@struct.header title="Recurring expense report" addCategoryIcons=true/>
<p>
    Hi ${firstName},<br/>
    Please find bellow a report of your recurring expenses
</p>
<p>
<ul>
    <#list expenses as expense>
        <li class="expense"><i class="cat ${expense.getCategory().getIcon()}" ></i> <span class="amount">${expense.getAmount()?string["0.00"]}</span>, <small>next occurrence: ${expense.getNextOccurrence()?string('yyyy-MM-dd')}</small></li>
    </#list>
</ul>
</p>


<@struct.footer  footerUrl=footerUrl/>

