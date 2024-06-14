async function pgpGenerateKey(userID, email, passphrase) {
    const keyPair = await openpgp.generateKey({
        type: 'rsa', // Type of the key
        rsaBits: 4096, // RSA key size (defaults to 4096 bits)
        userIDs: [{ name: userID, email: email }], // you can pass multiple user IDs
        passphrase: passphrase // protects the private key
    });

    const privateKey = keyPair.privateKey;
    const publicKey = keyPair.publicKey;

    //Mostrar la key en un campo de la vista
    document.getElementById("pubKey").value=keyPair.publicKey;
    document.getElementById("privKey").value=keyPair.privateKey;

    return;
}

function copyToClipboard(elementId) {
    const copyText = document.getElementById(elementId);
    copyText.select();
    copyText.setSelectionRange(0, 99999); // For mobile devices
    document.execCommand("copy");
    alert("Copied to clipboard");
}