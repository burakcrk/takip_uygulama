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
      home: AnaIskelet(),
    );
  }
}

// ====================================================================
// --- ANA İSKELET (SABİT MENÜYÜ VE SAYFALARI YÖNETEN BEYİN) ---
// ====================================================================

// AnaIskelet widgeti
// AnaIskelet içerisindeki yapılar uygulama çalışırken değişebileceği için StatefulWidget olarak tanımladık
class AnaIskelet extends StatefulWidget {
  const AnaIskelet({super.key}); // EKLENEN SATIR BURASI

  @override
  // Anasayfa içerisindeki işlemleri yapması için _AnaIskeletState() sınıfını oluşturur
  State<AnaIskelet> createState() => _AnaIskeletState();
}

class _AnaIskeletState extends State<AnaIskelet> {
  // --- MERKEZİ VERİLER ---
  // SİHİRLİ DEĞİŞKEN: Hangi sekmede olduğumuzu tutar. Başlangıçta 0 (Ana Sayfa)
  int seciliMenuIndex = 0;

  String eklemeTuru = "Görev"; 

  List<String> mesajListesi = [];
  int sayac = 1;
  DateTime seciliTarih = DateTime.now();
  final List<String> turkceGunler = ["", "Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"];
  TextEditingController t1 = TextEditingController();

  // --- FONKSİYONLAR ---
  void buguneDon() {
    setState(() { seciliTarih = DateTime.now(); });
  }

  void mesajEkle() {
    setState(() {
      if (t1.text.isNotEmpty) {
        mesajListesi.insert(0, "$sayac. [$eklemeTuru] - ${t1.text}");
        sayac++;
        t1.clear();
        
        // MÜKEMMEL UX DOKUNUŞU: Görev eklenince otomatik Ana Sayfaya (listeye) dön!
        seciliMenuIndex = 0; 
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
  }

  void tumMesajSil() {
    setState(() {
      mesajListesi.clear();
      sayac = 1;
    });
  }

  void eklemeSecenekleriniGoster() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)), // Üst köşeleri yuvarlat
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 250, // Menünün yüksekliği
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ne eklemek istersiniz?", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 20),
              
              // 1. SEÇENEK: GÖREV
              ListTile(
                leading: const Icon(Icons.check_circle_outline, color: Colors.blue, size: 30),
                title: const Text("Yeni Görev", style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.pop(context); // Önce alttan açılan menüyü kapat
                  setState(() { 
                    eklemeTuru = "Görev"; // Türü belirle
                    seciliMenuIndex = 2;  // Ekleme sayfasına git
                  });
                },
              ),
              
              // 2. SEÇENEK: NOT
              ListTile(
                leading: const Icon(Icons.note_alt_outlined, color: Colors.orange, size: 30),
                title: const Text("Yeni Not", style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.pop(context); 
                  setState(() { 
                    eklemeTuru = "Not"; 
                    seciliMenuIndex = 2; 
                  });
                },
              ),
            ],
          ),
        );
      }
    );
  }


  // ====================================================================
  // --- 1. SAYFA: ANA SAYFA ---
  // ====================================================================

  Widget _buildAnaSayfa() {
    return Column(
      children: [
        // ÜST BİLGİ / MENÜ BARI
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
        SizedBox(height: 20), 

        // TAKVİM ŞERİDİ
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, 
            itemCount: 30, 
            itemBuilder: (context, index) {
              DateTime dongudekiTarih = DateTime.now().subtract(const Duration(days: 15)).add(Duration(days: index));
              bool buGunSeciliMi = dongudekiTarih.day == seciliTarih.day && 
                                   dongudekiTarih.month == seciliTarih.month && 
                                   dongudekiTarih.year == seciliTarih.year;

              return GestureDetector( 
                onTap: () { setState(() { seciliTarih = dongudekiTarih; }); },
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
                            fontWeight: FontWeight.bold, fontSize: 16,
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
        SizedBox(height: 20),

        // KAYIT GEÇMİŞİ
        Expanded(
          child: SingleChildScrollView( 
            child: Text(
              mesajListesi.isEmpty 
                  ? "Henüz kayıt yok.\nEklemek için aşağıdaki yeşil (+) butonuna basın." 
                  : mesajListesi.join("\n\n"),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            ),
          ),
        ),
      ],
    );
  }

  // ====================================================================
  // --- SAYFA 2: GÖREV EKLEME SAYFASI ---
  // ====================================================================
  Widget _buildGorevEklemeSayfasi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("YENİ KAYIT EKLE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFFD63E63))),
        SizedBox(height: 30),
        TextField(
          controller: t1,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Yazı Yazın",
            fillColor: Colors.white, 
            filled: true,
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: ElevatedButton(onPressed: mesajEkle, child: Text("Gönder"))),
            SizedBox(width: 5),
            Expanded(child: ElevatedButton(onPressed: sonMesajSil, child: Text("Son Sil"))),
            SizedBox(width: 5),
            Expanded(child: ElevatedButton(onPressed: tumMesajSil, child: Text("Tüm Sil"))),
          ],
        ),
      ],
    );
  }

  // ====================================================================
  // --- ANA EKRANIN İNŞASI (BUILD) ---
  // ====================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEEED), 
      
      // DEĞİŞKEN GÖVDE: Menüden hangisi seçiliyse sadece o "Widget" ekrana basılır.
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: seciliMenuIndex == 0 
              ? _buildAnaSayfa() 
              : (seciliMenuIndex == 2 ? _buildGorevEklemeSayfasi() : Center(child: Text("Bu sayfa yakında eklenecek!"))),
        ),
      ),

      // SABİT ALT MENÜ
      bottomNavigationBar: Container(
        color: Colors.white, 
        child: SafeArea( 
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                // 1. İKON (Anasayfa - Index: 0)
                IconButton(
                  icon: Icon(Icons.home, size: 30, color: seciliMenuIndex == 0 ? const Color(0xFFD63E63) : Colors.grey), 
                  onPressed: () { setState(() { seciliMenuIndex = 0; }); }, 
                ),
                // 2. İKON (İstatistik - Index: 1)
                IconButton(
                  icon: Icon(Icons.bar_chart, size: 30, color: seciliMenuIndex == 1 ? const Color(0xFFD63E63) : Colors.grey),
                  onPressed: () { setState(() { seciliMenuIndex = 1; }); }, 
                ),
                // 3. İKON (Ekleme Butonu - Index: 2)
                IconButton(
                  icon: Icon(Icons.add_circle, size: 45, color: seciliMenuIndex == 2 ? const Color(0xFFD63E63) : Colors.green), 
                  onPressed: () { setState(() { eklemeSecenekleriniGoster(); }); }, 
                ),
                // 4. İKON (Hedefler - Index: 3)
                IconButton(
                  icon: Icon(Icons.track_changes, size: 30, color: seciliMenuIndex == 3 ? const Color(0xFFD63E63) : Colors.grey),
                  onPressed: () { setState(() { seciliMenuIndex = 3; }); }, 
                ),
                // 5. İKON (Profil - Index: 4)
                IconButton(
                  icon: Icon(Icons.person, size: 30, color: seciliMenuIndex == 4 ? const Color(0xFFD63E63) : Colors.grey),
                  onPressed: () { setState(() { seciliMenuIndex = 4; }); }, 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



