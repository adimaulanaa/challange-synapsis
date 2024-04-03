Cara membuat KeyStore untuk release apk

- open terminal lalu run code di bawah

keytool -genkey -v -keystore /Users/admin/Code/keystore/upload-keystore.jks -keyalg RSA \ -keysize 2048 -validity 10000 -alias upload

** /Users/admin/Code/keystore/ => adalah path file keystore (bisa di ganti sesuai keinginan)
** upload-keystore.jks => nama dari keystore (ini bisa di ubah sesuai keiginan)
** upload => adalah alias yang di pakai nanti di file key.properties

- masukan password sesuai kebutuhan 
- masukan nama sesuai kebutuhan
- dan yang lain bisa di enter saja
- jika pertanyaan ini "Is CN=Adi Maulana, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown correct?" bisa di pilih YES/yes 
- selesai