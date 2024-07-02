function showDecControls() {
    document.getElementById("decryptControls").style="display: block";
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
    
    const { data: decrypted, signature } = await openpgp.decrypt({
        message,
        verificationKeys: "", // optional
        decryptionKeys: privateKey
    });

    //write data into textarea
    //Puts the pass clear-text in the textarea
    document.getElementById("copyBtn").style = "display: block";
    document.getElementById("passDecrypted").style = "display: block";
    document.getElementById("passDecrypted").value = decrypted;
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