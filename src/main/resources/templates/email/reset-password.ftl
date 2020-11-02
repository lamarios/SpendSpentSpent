<#import "./struct.ftl" as struct>

<@struct.header title="Reset password request" />
<p>
    Hi ${firstName},<br />
    You've requested a password reset for SpendSpentSpent, you can proceed to: <a href="${url}">${url}</a> to reset your
    password. The link will expire in 24 hours.
</p>
<p>If you did not request for this, you can ignore this email.</p>

<@struct.footer  footerUrl=footerUrl/>

