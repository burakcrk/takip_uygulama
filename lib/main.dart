// 1. Flutter'ın görsel kütüphanesini çağırdık.
import 'package:flutter/material.dart';

// 2. Uygulamayı başlatan komut.
void main() {
  runApp(const BenimUygulamam());
}

// 3. Uygulamanın temelini oluşturan class
// Uygulamanın temel ayarlarını ve başlatıldığında neler olacağını ayarlar
// Buradaki yapılar uygulama çalışırken değişmeyeceği için StatelessWidget olarak tanımladık
class BenimUygulamam extends StatelessWidget {
  const BenimUygulamam({super.key});
  
  @override
  // MaterialApp uygulamanın temel widget'i gibi bir şey
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Sağ üstteki "Debug" bandını kaldırır
      home: AnaSayfa(),
    );
  }
}

// Anasayfa widgeti
// Anasayfa içerisindeki yapılar uygulama çalışırken değişebileceği için StatefulWidget olarak tanımladık
class AnaSayfa extends StatefulWidget {
  @override
  // Anasayfa içerisindeki işlemleri yapması için _AnaSayfaState() sınıfını oluşturur
  State<AnaSayfa> createState() => _AnaSayfaState();
}

// AnaSayfa widget'i üzerinde işlemleri yapacak olan state
class _AnaSayfaState extends State<AnaSayfa> {

  // Textbox'ın içindekini okumak için bir kontrolcü
  TextEditingController t1 = TextEditingController();
  
  // Ekrana yazdıracağımız değişken
  List<String> mesajListesi  = [];

  int sayac = 1;

  // Butona basılınca çalışacak fonksiyon
  void mesajEkle() {
    // setState: Flutter'ın en önemli sihirli kelimesidir!
    // Eğer setState kullanmazsanız değişken değişir ama EKRAN YENİLENMEZ.
    // setState "Ekranı güncelle, yeni verileri göster" demektir.
    setState(() {
      if (t1.text.isNotEmpty) {
        String yeniMesaj = "$sayac. ${t1.text}";

        mesajListesi.insert(0, yeniMesaj);

        sayac++;
        t1.clear();
      }
    });
  }

  void sonMesajSil() {
    setState(() {
      if (mesajListesi.isNotEmpty) {
        mesajListesi.removeAt(0);
        sayac--;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Son Mesaj Silindi"), // Mesaj içeriği
        duration: Duration(seconds: 2), // Ne kadar ekranda kalsın?
        backgroundColor: Colors.red, // Arkaplan rengi
      ),
    );
  }

  void tumMesajSil() {
    setState(() {
      if (mesajListesi.isNotEmpty) {
        mesajListesi.clear();
        sayac = 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tüm Mesajlar Silindi"), // Mesaj içeriği
        duration: Duration(seconds: 2), // Ne kadar ekranda kalsın?
        backgroundColor: Colors.red, // Arkaplan rengi
      ),
    );
  }

  @override
  // setState her tetiklendiğinde burası çalışır
  Widget build(BuildContext context) {
    return Scaffold(
      // Yukarıdaki bar
      appBar: AppBar(
        title: Text("Masturnasyonel Takip Uygulaması"),
        backgroundColor: const Color.fromARGB(255, 43, 255, 0), // Başlık rengi
      ),
      // Uygulamanın gövdesi
      // Padding ile 4 yönden ana gövdenin kenarlarına boşluklar koymuş olduk
      body: Padding(
        padding: const EdgeInsets.all(10.0), // Kenarlardan bıraktığımız boşluk 10 birim
        // Gövde içerisinde yapıları dizmek  için oluşturduğumuz raf sistemi
        // "Column" ile dikey bir şekilde sıralama yaparız
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Her şeyi ortaya hizala
          // raf içerisindeki eşyalar
          children: [

            // 1. BİLEŞEN: TEXTBOX (Giriş Kutusu)
            TextField(
              controller: t1, // Casusumuzu buraya atadık
              decoration: InputDecoration(
                border: OutlineInputBorder(), // Kutunun etrafına çizgi çeker
                labelText: "Yazı Yazın", // İpucu yazısı
              ),
            ),
            
            SizedBox(height: 20), // Araya boşluk koyar

            // 2. BİLEŞEN: BUTONLAR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                  onPressed: mesajEkle, // Tıklanınca yukarıdaki fonksiyonu çalıştır
                  child: Text("Yazıyı Gönder"),
                  ),
                ),
                
                SizedBox(width: 10), // Araya boşluk koyar

                Expanded(
                  child: ElevatedButton(
                  onPressed: sonMesajSil, // Tıklanınca yukarıdaki fonksiyonu çalıştır
                  child: Text("Son Yazıyı Sil"),
                  ),
                ),

                SizedBox(width: 10), // Araya boşluk koyar

                Expanded(
                  child: ElevatedButton(
                  onPressed: tumMesajSil, // Tıklanınca yukarıdaki fonksiyonu çalıştır
                  child: Text("Tüm Yazıları Sil"),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20), // Araya boşluk koyar

            // 3. BİLEŞEN: SONUÇ ETİKETİ (Label)
            Text(
              mesajListesi.join("\n\n"), // Yukarıdaki değişkeni burada gösteriyoruz
              style: TextStyle(fontSize: 24, color: Colors.deepPurple), // Yazı tipi ayarı
            ),
          ],
        ),
      ),
    );
  }
}