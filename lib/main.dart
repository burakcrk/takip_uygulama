import 'package:flutter/material.dart';

void main() {
  runApp(const BenimUygulamam());
}

class BenimUygulamam extends StatelessWidget {
  const BenimUygulamam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnaIskelet(), 
    );
  }
}

// ====================================================================
// --- ANA İSKELET ---
// ====================================================================

class AnaIskelet extends StatefulWidget {
  const AnaIskelet({super.key});

  @override
  State<AnaIskelet> createState() => _AnaIskeletState();
}

class _AnaIskeletState extends State<AnaIskelet> {
  int seciliMenuIndex = 0; 
  String eklemeTuru = "Görev"; 
  
  // YENİ: ComboBox (Açılır Liste) için değişkenlerimiz
  String secilenGorevTipi = "Tek Seferlik";
  final List<String> gorevTipleri = ["Tek Seferlik", "Rutin"];

  List<String> mesajListesi = [];
  int sayac = 1;
  DateTime seciliTarih = DateTime.now();
  final List<String> turkceGunler = ["", "Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"];
  TextEditingController t1 = TextEditingController();

  void buguneDon() {
    setState(() { seciliTarih = DateTime.now(); });
  }

  void mesajEkle() {
    setState(() {
      if (t1.text.isNotEmpty) {
        // Listeye eklerken artık "Rutin" mi "Tek Seferlik" mi onu da yazdırıyoruz
        mesajListesi.insert(0, "$sayac. [$secilenGorevTipi] - ${t1.text}");
        sayac++;
        t1.clear();
        
        seciliMenuIndex = 0; // İşlem bitince ana sayfaya dön
        
        // Ekleme sonrası ComboBox'ı tekrar varsayılana çekelim
        secilenGorevTipi = "Tek Seferlik"; 
      }
    });
  }

  // SİLME İŞLEMLERİ ARTIK SADECE ANA SAYFADA (Listeyi temizlemek için koda dokunmadık ama ekrandan kaldırdık)
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)), 
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 250, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ne eklemek istersiniz?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.check_circle_outline, color: Colors.blue, size: 30),
                title: const Text("Yeni Görev", style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.pop(context); 
                  setState(() { 
                    eklemeTuru = "Görev"; 
                    seciliMenuIndex = 2; 
                  });
                },
              ),
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
  // --- SAYFA 1: ANA SAYFA ---
  // ====================================================================
  Widget _buildAnaSayfa() {
    return Column(
      children: [
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

        // Test amaçlı silme butonlarını şimdilik ana sayfanın altına küçükçe ekledim
        // (İlerde bunları görevlerin yanına "çöp kutusu" ikonu olarak koyacağız)
        if(mesajListesi.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: sonMesajSil, child: Text("Son Sil", style: TextStyle(color: Colors.red))),
              TextButton(onPressed: tumMesajSil, child: Text("Tümünü Sil", style: TextStyle(color: Colors.red))),
            ],
          ),

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
  // --- SAYFA 2: YENİ GÜNCEL GÖREV EKLEME SAYFASI ---
  // ====================================================================
  Widget _buildGorevEklemeSayfasi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // İçindeki elemanları sağa sola tam yayar
      children: [
        // 1. SOL ÜST GERİ BUTONU VE BAŞLIK
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 30),
              onPressed: () {
                setState(() {
                  seciliMenuIndex = 0; // Geri butonuna basınca Ana Sayfaya dön
                });
              },
            ),
            const Expanded(
              child: Text(
                "Kayıt Ekle", 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD63E63))
              ),
            ),
            const SizedBox(width: 48), // Başlığı tam ortalamak için sol ikon kadar sağa boşluk bıraktık
          ],
        ),
        const SizedBox(height: 30),

        // 2. COMBOBOX (DropdownButton)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline( // Altındaki varsayılan siyah çizgiyi gizler
            child: DropdownButton<String>(
              value: secilenGorevTipi,
              isExpanded: true, // Kutuyu tam genişliğe yayar
              icon: const Icon(Icons.arrow_drop_down, size: 30),
              items: gorevTipleri.map((String tip) {
                return DropdownMenuItem<String>(
                  value: tip,
                  child: Text(tip, style: const TextStyle(fontSize: 18)),
                );
              }).toList(),
              onChanged: (String? yeniSecim) {
                if (yeniSecim != null) {
                  setState(() {
                    secilenGorevTipi = yeniSecim; // Seçimi güncelle
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 3. TEXTBOX
        TextField(
          controller: t1,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Görevin İsmi",
            fillColor: Colors.white, 
            filled: true,
          ),
        ),
        const SizedBox(height: 30),

        // 4. KAYDET BUTONU
        ElevatedButton(
          onPressed: mesajEkle,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Yeşil buton
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15), // Butonu biraz şişmanlaştırdık
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          ),
          child: const Text("Kaydet", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: seciliMenuIndex == 0 
              ? _buildAnaSayfa() 
              : (seciliMenuIndex == 2 ? _buildGorevEklemeSayfasi() : Center(child: Text("Bu sayfa yakında eklenecek!"))),
        ),
      ),

      // --- SİHİRLİ DOKUNUŞ: ALT MENÜNÜN GİZLENMESİ ---
      // Eğer seciliMenuIndex 2 (Ekleme Sayfası) ise menüyü 'null' yapıp gizle. Değilse göster.
      bottomNavigationBar: seciliMenuIndex == 2 
      ? null 
      : Container(
        color: Colors.white, 
        child: SafeArea( 
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                IconButton(icon: Icon(Icons.home, size: 30, color: seciliMenuIndex == 0 ? const Color(0xFFD63E63) : Colors.grey), onPressed: () { setState(() { seciliMenuIndex = 0; }); }),
                IconButton(icon: Icon(Icons.bar_chart, size: 30, color: seciliMenuIndex == 1 ? const Color(0xFFD63E63) : Colors.grey), onPressed: () { setState(() { seciliMenuIndex = 1; }); }),
                IconButton(
                  icon: Icon(Icons.add_circle, size: 45, color: seciliMenuIndex == 2 ? const Color(0xFFD63E63) : Colors.green), 
                  onPressed: () { eklemeSecenekleriniGoster(); }, 
                ),
                IconButton(icon: Icon(Icons.track_changes, size: 30, color: seciliMenuIndex == 3 ? const Color(0xFFD63E63) : Colors.grey), onPressed: () { setState(() { seciliMenuIndex = 3; }); }),
                IconButton(icon: Icon(Icons.person, size: 30, color: seciliMenuIndex == 4 ? const Color(0xFFD63E63) : Colors.grey), onPressed: () { setState(() { seciliMenuIndex = 4; }); }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}