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

  void buguneDon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Bu butonun fonksiyonu henüz tanımlanmadı"), // Mesaj içeriği
        duration: Duration(seconds: 2), // Ne kadar ekranda kalsın?
        backgroundColor: Colors.red, // Arkaplan rengi
      ),
    );
  }

  @override
  // setState her tetiklendiğinde burası çalışır
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEEED), // Arkaplan Rengi

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            children: [

              // 0. BİLEŞEN: EN ÜST BAR (SIDEBAR, TODAY, CALENDER)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.menu, size: 30),
                  ElevatedButton(
                    onPressed: buguneDon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD63E63),
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Bugün", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Icon(Icons.calendar_month, size: 30),
                ],
              ),

              // --ARA BOŞLUK--
              SizedBox(height: 20),

              // 1. BİLEŞEN: TAKVİM BARI
              SizedBox(
                height: 100, // Takvimin yüksekliği
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, 
                  itemCount: 30, 
                  itemBuilder: (context, index) {
                    DateTime dongudekiTarih = DateTime.now().subtract(const Duration(days: 15)).add(Duration(days: index));
                    bool buGunSeciliMi = dongudekiTarih.day == seciliTarih.day && 
                                         dongudekiTarih.month == seciliTarih.month && 
                                         dongudekiTarih.year == seciliTarih.year;

                    return GestureDetector( 
                      onTap: () {
                        setState(() { seciliTarih = dongudekiTarih; });
                      },
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: buGunSeciliMi ? const Color(0xFFD63E63) : Colors.white, 
                          borderRadius: BorderRadius.circular(30), 
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              turkceGunler[dongudekiTarih.weekday], 
                              style: TextStyle(
                                color: buGunSeciliMi ? Colors.white : Colors.black87, 
                                fontWeight: buGunSeciliMi ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: buGunSeciliMi ? Colors.transparent : Colors.grey.shade200, 
                              ),
                              child: Text(
                                dongudekiTarih.day.toString(), 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16,
                                  color: buGunSeciliMi ? Colors.white : Colors.black, 
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // --ARA BOŞLUK--
              SizedBox(height: 20),

              // 3. BİLEŞEN: TEXTBOX (Giriş Kutusu)
              TextField(
                controller: t1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Yazı Yazın",
                  fillColor: Colors.white, 
                  filled: true,
                ),
              ),

              // --ARA BOŞLUK--
              SizedBox(height: 20),

              // 4. BİLEŞEN: BUTONLAR
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: mesajEkle, child: Text("Gönder"))),
                  SizedBox(width: 5), // Butonlar arası yatay boşluk
                  Expanded(child: ElevatedButton(onPressed: sonMesajSil, child: Text("Son Sil"))),
                  SizedBox(width: 5), // Butonlar arası yatay boşluk
                  Expanded(child: ElevatedButton(onPressed: tumMesajSil, child: Text("Tüm Sil"))),
                ],
              ),

              // --ARA BOŞLUK--
              SizedBox(height: 20),

              // 5. BİLEŞEN: KAYIT GEÇMİŞİ
              Expanded(
                child: SingleChildScrollView( 
                  // İçerik tamamen doldurursa ekranı yukarı/aşağı kaydırmayı sağlar
                  child: Text(
                    mesajListesi.join("\n\n"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.deepPurple),
                  ),
                ),
              ),

            ], 
          ),
        ),
      ),




    );
  }
}