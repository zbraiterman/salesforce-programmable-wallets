const encryptData = async (pemKey, data) => {
    const publicKey = await importPublicKey(pemKey);
    const encryptedData = await window.crypto.subtle.encrypt(
        {
            name: 'RSA-OAEP'
        },
        publicKey,
        hexToArrayBuffer(data)
    );

    return btoa(String.fromCharCode(...new Uint8Array(encryptedData)));
};

const importPublicKey = async pemKey => {
    const pemContents = pemKey.replace(/-----(BEGIN|END) PUBLIC KEY-----|\n/g, '');
    const binaryDer = atob(pemContents);
    const binaryArray = new Uint8Array(binaryDer.split('').map(char => char.charCodeAt(0)));

    return await crypto.subtle.importKey(
        'spki',
        binaryArray.buffer,
        {
            name: 'RSA-OAEP',
            hash: { name: 'SHA-256' }
        },
        false,
        ['encrypt']
    );
};

const hexToArrayBuffer = hex => {
    const byteArray = new Uint8Array(hex.match(/.{1,2}/g).map(byte => parseInt(byte, 16)));
    return byteArray.buffer;
};

export { encryptData };
