function showDecControls() {
    //document.getElementById("decryptControls").style="display: block";
    document.getElementById("decryptControls").classList.toggle("d-none");
    return;
}

function fireFlash(message){
    let container = document.getElementsByTagName("main")[0].firstChild.nextElementSibling;
    let div = document.createElement('div');
    div.classList.add("alert", "alert-dismissible", "fade", "show", "alert-danger");
    div.setAttribute("role", "alert");
    let msg = document.createElement('p')
    msg.innerHTML = message;
    div.append(msg);
    let closeBtn = document.createElement('button');
    closeBtn.classList.add("btn-close");
    closeBtn.setAttribute("type", "button");
    closeBtn.setAttribute("data-bs-dismiss", "alert");
    closeBtn.setAttribute("aria-label", "Close");
    div.append(closeBtn);
    container.prepend(div);
    return;
}

async function pgpDecrypt(passphrase, email) {
    const privateKeyArmored = document.getElementById("privateKey").value;
    const privateKey = await openpgp.decryptKey({
            privateKey: await openpgp.readPrivateKey({ armoredKey: privateKeyArmored }),
            passphrase
    });
    const armoredMessageUsername = document.getElementById("username").value;
    const messageUsername = await openpgp.readMessage({ armoredMessage: armoredMessageUsername });
    
    let decryptedUsername;
    try {
        const resultUsername = await openpgp.decrypt({
            message: messageUsername,
            verificationKeys: "", // optional
            decryptionKeys: privateKey
        });

    decryptedUsername = resultUsername.data;

    } catch (error) {
        //show flash error to view
        fireFlash(error.message);
        return;
    }

    const armoredMessagePass = document.getElementById("pass").value;
    const messagePass = await openpgp.readMessage({ armoredMessage: armoredMessagePass });
    
    let decryptedPass;
    try {
        const resultPass = await openpgp.decrypt({
            message: messagePass,
            verificationKeys: "", // optional
            decryptionKeys: privateKey
        });

    decryptedPass = resultPass.data;

    } catch (error) {
        //show flash error to view
        fireFlash(error.message);
        return;
    }

    //write data into textarea
    //Puts the pass clear-text in the textarea
    document.getElementById("copyBtn_username").classList.toggle("d-none");
    document.getElementById("copyBtn_pass").classList.toggle("d-none");
    document.getElementById("userDecrypted").classList.toggle("d-none");
    document.getElementById("userDecrypted").value = decryptedUsername;
    document.getElementById("passDecrypted").classList.toggle("d-none");
    document.getElementById("passDecrypted").value = decryptedPass;
    document.getElementById("passDecrypted").focus();
    return;
}

function handleFileSelect() {
  const input = document.getElementById('file-input');
  const file = input.files[0];
  const reader = new FileReader();
  reader.onload = function() {
    const contents = reader.result;
    document.getElementById("privateKey").value = contents;
    document.getElementById("privateKey").classList.toggle("d-none");
    document.getElementById("privateKey_heading").classList.toggle("d-none");
    document.getElementById("go_btn").classList.toggle("d-none");
    return;
  };
  reader.readAsText(file);
}

function copyToClipboard(elementId) {
    const copyText = document.getElementById(elementId);
    copyText.select();
    copyText.setSelectionRange(0, 99999); // For mobile devices
    document.execCommand("copy");
    alert("Copied to clipboard");
}