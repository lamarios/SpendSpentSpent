<#import "./struct.ftl" as struct>

<@struct.header title="Welcome to SpendSpentSpent !" />
<p>
    Hi ${firstName},<br/>
    Welcome to SpendSpentSpent. This is just a new registration confirmation email to let you know that all went well.
    No action is required on your side.
</p>
<p>
    You can start using SpendSpentSpent by logging in at <a href="${footerUrl}">${footerUrl}</a>
</p>

<@struct.footer  footerUrl=footerUrl/>

