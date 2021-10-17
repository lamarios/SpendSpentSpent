<#import "struct.ftl" as struct>

<@struct.header title="Reset password" />

<div id="errors"></div>
<div>
    <label>New password:</label>
    <br/>
    <input type="password" id="password" required/>
</div>

<div>
    <label>Repeat password:</label>
    <br/>
    <input type="password" id="password2" required/>
</div>
<button onclick="resetPassword()">Send</button>

<script>

    function resetPassword() {
        const password = document.getElementById('password').value;
        const password2 = document.getElementById('password2').value;

        if (password.trim().length === 0 || password2.trim().length === 0) {
            alert('Please fill all the fields');
        }

        if (password !== password2) {
            alert('Passwords are different');
        }

        fetch('/ResetPassword', {
            method: 'POST',
            body: JSON.stringify({
                    resetId: '${resetId}',
                    newPassword: password,
                },
            ),
            headers: {
                'Content-Type': 'application/json'
            }
        }).then(resp => alert('Password reset successfully'));

    }
</script>