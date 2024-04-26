package org.tfg.upm.customEngine.certificates;

import java.io.FileOutputStream;
import java.math.BigInteger;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.Security;
import java.security.cert.X509Certificate;
import java.util.Date;

import org.bouncycastle.asn1.x500.X500Name;
import org.bouncycastle.asn1.x509.SubjectPublicKeyInfo;
import org.bouncycastle.cert.X509v3CertificateBuilder;
import org.bouncycastle.cert.jcajce.JcaX509CertificateConverter;
import org.bouncycastle.cert.jcajce.JcaX509v3CertificateBuilder;
import org.bouncycastle.operator.ContentSigner;
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.pqc.jcajce.provider.dilithium.BCDilithiumPublicKey;



public class CA_Dilithium {

    public static void main(String[] args) throws Exception {
        Security.addProvider(new BouncyCastleProvider());

        // Generar par de claves Dilithium3
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("DILITHIUM3", "BC");
        KeyPair keyPair = keyPairGenerator.generateKeyPair();

        // Generar certificado X.509
        X509Certificate certificate = generateCertificate(keyPair);

        // Guardar el certificado y la clave privada en archivos
        FileOutputStream keyOut = new FileOutputStream("/home/ithaqua/Desktop/ca/ca.key");
        keyOut.write(keyPair.getPrivate().getEncoded());
        keyOut.close();

        FileOutputStream certOut = new FileOutputStream("/home/ithaqua/Desktop/ca/ca.crt");
        certOut.write(certificate.getEncoded());
        certOut.close();

        System.out.println("Certificado y clave generados con éxito.");
    }

    private static BigInteger generateUniqueSerialNumber() {
        return BigInteger.valueOf(System.currentTimeMillis());
    }

    private static X509Certificate generateCertificate(KeyPair keyPair) throws Exception {
        // Configurar el emisor y el sujeto del certificado
        X500Name issuer = new X500Name("C=ES, O=KafkaTFG, L=Madrid, CN=KafkaTFG-ca");
        X500Name subject = new X500Name("C=ES, O=KafkaTFG, L=Madrid, CN=KafkaTFG-ca");

        // Generar número de serie único
                BigInteger serialNumber = generateUniqueSerialNumber();

        // Convertir PublicKey a SubjectPublicKeyInfo
        BCDilithiumPublicKey dilithiumPublicKey = (BCDilithiumPublicKey) keyPair.getPublic();
        SubjectPublicKeyInfo subjectPublicKeyInfo = SubjectPublicKeyInfo.getInstance(dilithiumPublicKey.getEncoded());

        // Crear constructor de certificado X.509
                X509v3CertificateBuilder certificateBuilder = new JcaX509v3CertificateBuilder(
                        issuer,
                        generateUniqueSerialNumber(),
                        new Date(System.currentTimeMillis()),
                        new Date(System.currentTimeMillis() + 365 * 24 * 60 * 60 * 1000L),
                        subject,
                        subjectPublicKeyInfo
                );

        // Crear el firmante de contenido
        ContentSigner contentSigner = new JcaContentSignerBuilder("DILITHIUM3").build(keyPair.getPrivate());

        // Construir el certificado X.509
        return new JcaX509CertificateConverter().getCertificate(certificateBuilder.build(contentSigner));
    }
}

