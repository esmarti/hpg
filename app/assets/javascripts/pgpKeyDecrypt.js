function showDecControls() {
    //document.getElementById("decryptControls").style="display: block";
    document.getElementById("decryptControls").classList.toggle("d-none");
    return;
}

async function pgpDecrypt(passphrase, email) {
    const privateKeyArmored = document.getElementById("privateKey").value;
    const privateKey = await openpgp.decryptKey({
            privateKey: await openpgp.readPrivateKey({ armoredKey: privateKeyArmored }),
            passphrase
    });
    const armoredMessage = document.getElementById("pass").value;
    const message = await openpgp.readMessage({ armoredMessage: armoredMessage });
    
    let decrypted;
    try {
        const result = await openpgp.decrypt({
            message: message,
            verificationKeys: "", // optional
            decryptionKeys: privateKey
        });

    decrypted = result.data;

    } catch (error) {
        //show flash error to view
        let container = document.getElementsByTagName("main")[0].firstChild.nextElementSibling;
        let div = document.createElement('div');
        div.classList.add("alert", "alert-dismissible", "fade", "show", "alert-danger");
        div.setAttribute("role", "alert");
        let msg = document.createElement('p')
        msg.innerHTML = error.message;
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

    //write data into textarea
    //Puts the pass clear-text in the textarea
    document.getElementById("copyBtn").style = "display: block";
    document.getElementById("passDecrypted").style = "display: block";
    document.getElementById("passDecrypted").value = decrypted;
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
    document.getElementById("privateKey").style="display: block";
    document.getElementById("go_btn").style="display: block";
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