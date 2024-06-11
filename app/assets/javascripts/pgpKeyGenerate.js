(async () => {
    const keyPair = await openpgp.generateKey({
        type: 'rsa', // Type of the key
        rsaBits: 4096, // RSA key size (defaults to 4096 bits)
        userIDs: [{ name: 'Jon Smith', email: 'jon@example.com' }], // you can pass multiple user IDs
        passphrase: 'super long and hard to guess secret' // protects the private key
    });

const privateKey = keyPair.privateKey;
const publicKey = keyPair.publicKey;

console.log("privateKey: "+keyPair.privateKey);
console.log("publicKey: "+keyPair.publicKey);
})();