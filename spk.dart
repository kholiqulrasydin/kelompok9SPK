import 'dart:math';
import 'dart:io';
import 'dart:convert';

class DummyData{
  static final List<Sepatu> listSepatu = [
    Sepatu(uid: "97asjdi13", merk: 'Nike', name: "Air Jordan 1 Mid Women's white", gender: 'Perempuan', bahan: ['Sintetis', 'Karet'], harga: 1999000, purpose: ['Berjalan, Joging, Bersantai']),
    Sepatu(uid: "sdfjh2983", merk: 'Nike', name: "Air Jordan 1 Mid Men's black", gender: 'Unisex', bahan: ['Sintetis', 'Karet'], harga: 1999000, purpose: ['Berjalan, Joging, Bersantai']),
    Sepatu(uid: "asda356g2", merk: 'Nike', name: "Nike Air Jordan", gender: 'Unisex', bahan: ['Sintetis', 'Karet'], harga: 1040000, purpose: ['Berjalan, Joging, Bersantai']),
    Sepatu(uid: "af135gsdg", merk: 'Nike', name: "Go flyease", gender: 'Mens', bahan: ['Sintetis', 'Karet'], harga: 1200000, purpose: ['Berjalan, Joging, Bersantai']),
    Sepatu(uid: "0u37fnsdf", merk: 'Nike', name: "Nike Air Force", gender: 'Mens', bahan: ['Sintetis', 'Karet'], harga: 1450000, purpose: ['Berjalan, Joging, Bersantai']),
    Sepatu(uid: "bvnhe82ks", merk: 'Sketchers', name: "Cortez", gender: 'Unisex', bahan: ['Sintetis', 'Karet'], harga: 1100000, purpose: ['Berjalan, Joging, Bersantai']),
    Sepatu(uid: "984jgfbok", merk: 'Sketchers', name: "Go walk", gender: 'Unisex', bahan: ['Sintetis', 'Karet'], harga: 780000, purpose: ['Berjalan, Joging, Bersantai']),
    Sepatu(uid: "813y4jewd", merk: 'Sketchers', name: "Go run", gender: 'Unisex', bahan: ['Sintetis', 'Karet'], harga: 950000, purpose: ['Berjalan, Joging, Bersantai']),
    Sepatu(uid: "asbadfuer", merk: 'Sketchers', name: "Go run Elevate", gender: 'Unisex', bahan: ['Sintetis', 'Karet'], harga: 650000, purpose: ['Berjalan, Joging, Bersantai']),
    Sepatu(uid: "nmbhky207", merk: 'Lacoste', name: "Carnaby Evo", gender: 'Mens', bahan: ['Sintetis', 'Karet'], harga: 1259000, purpose: ['Berjalan, Joging, Bersantai']),
    Sepatu(uid: "af539fujd", merk: 'Lacoste', name: "Eclipse", gender: 'Woman', bahan: ['Sintetis', 'Karet'], harga: 699500, purpose: ['Berjalan, Joging, Bersantai'])
  ];


}


class Sepatu{
  final String uid;
  final String merk;
  final String name;
  final String gender;
  final List<String> bahan;
  final int harga;
  final List<String> purpose;
  double ? hargaRate;
  double ? purposeRate;
  double ? bahanRate;
  double ? rate;

  Sepatu({required this.uid, required this.merk, required this.name, required this.gender, required this.bahan, required this.harga, required this.purpose, this.hargaRate, this.bahanRate, this.purposeRate, this.rate});
}



class Topsis{
  // List<int> harga = [650.000, 1.000.000];
  // List<String> purpose = ['Berjalan', 'Joging', 'Bersantai'];
  // List<String> bahan = ['Karet'];

  final List<int> harga;
  final List<String> purpose;
  final List<String> bahan;
  Topsis({required this.harga, required this.purpose, required this.bahan});

  // W = [5, 5, 5] (Bobot Preferensi)

  List<Sepatu> getResult(){
    List<Sepatu> sepatuResult = [];
    List<Sepatu> availableData = DummyData.listSepatu;
    late List<Sepatu> ratedSepatu;
    List<double> normalisasiHarga = [];
    List<double> normalisasiPurpose = [];
    List<double> normalisasiBahan = [];
    List<double> bahan = [];

    // harga rating (Kriteria 1 : harga)
    for(int i = 0; i<availableData.length; i++){
      if(availableData[i].harga > this.harga.first && availableData[i].harga < this.harga.last){
        availableData[i].hargaRate = 5;
      }else{
        availableData[i].hargaRate = 4;
      }
    }

    // kegunaan rating (Kriteria 2: kegunaan)
    for(int i = 0; i<availableData.length; i++){
      List<String> availablePurposeList = availableData[i].purpose;
      List<String> inputPurposeList = this.purpose;
      List<String> resultPurposeList = [];

      availablePurposeList.forEach((element) {
        inputPurposeList.forEach((e) {
          if(e == element){
            resultPurposeList.add(element);
          }
        });
      });

      double rate = inputPurposeList.length == resultPurposeList.length ? 5 : inputPurposeList.length > resultPurposeList.length ? resultPurposeList.length * resultPurposeList.length / inputPurposeList.length : inputPurposeList.length * inputPurposeList.length / resultPurposeList.length;
      availableData[i].purposeRate = rate;
    }

    // bahan rating (Kriteria 3: Bahan)
    for(int i = 0; i<availableData.length; i++){
      List<String> availableBahanList = availableData[i].bahan;
      List<String> inputBahanList = this.bahan;
      List<String> resultBahanList = [];

      availableBahanList.forEach((element) {
        inputBahanList.forEach((e) {
          if(e == element){
            resultBahanList.add(element);
          }
        });
      });

      double rate = inputBahanList.length == resultBahanList.length ? 5 : inputBahanList.length > resultBahanList.length ? resultBahanList.length * resultBahanList.length / inputBahanList.length : inputBahanList.length * inputBahanList.length / resultBahanList.length;
      availableData[i].bahanRate = rate;
    }

    // Buat matriks ternormalisasi dengan menggunakan persamaan

    double akarBobotPreferensi = sqrt((5*5) + (5*5) + (5*5));
//     print(akarBobotPreferensi.toString());

    // Normalisasi harga, kegunaan, bahan

    // availableData.forEach((element) {
    //   normalisasiHarga.add(element.hargaRate! / akarBobotPreferensi);
    // });
    //
    // availableData.forEach((element) {
    //   normalisasiPurpose.add(element.purposeRate! / akarBobotPreferensi);
    // });
    //
    // availableData.forEach((element) {
    //   normalisasiBahan.add(element.bahanRate! / akarBobotPreferensi);
    // });

    // Normalisasi harga, kegunaan, bahan

    availableData.forEach((element) => normalisasiHarga.add(element.hargaRate! / akarBobotPreferensi * akarBobotPreferensi));

    availableData.forEach((element) => normalisasiPurpose.add(element.purposeRate! / akarBobotPreferensi * akarBobotPreferensi));

    availableData.forEach((element) => normalisasiBahan.add(element.bahanRate! / akarBobotPreferensi * akarBobotPreferensi));

    List<double> solusiIdealHarga = normalisasiHarga;
    List<double> solusiIdealPurpose = normalisasiPurpose;
    List<double> solusiIdealBahan = normalisasiBahan;

    // mencari nilai A+ (max)
    normalisasiHarga.sort();
    normalisasiPurpose.sort();
    normalisasiBahan.sort();

    double aPlusHarga = normalisasiHarga.last;
    double aPlusPurpose = normalisasiPurpose.last;
    double aPlusBahan = normalisasiBahan.last;

    // mencari nilai A- (min)

    double aMinHarga = normalisasiHarga.first;
    double aMinPurpose = normalisasiPurpose.first;
    double aMinBahan = normalisasiBahan.first;

    // mencari jarak antar nilai terbobot

    List<Map<String, dynamic>> d = List.generate(availableData.length, (index) {
      List<String> lString = [];
      String rawString = solusiIdealHarga[index].toString();
      List<String> splittedString = rawString.split('');
      String hString = '';
      if(splittedString.length < 6){
        hString = rawString;
      }else{
        for(int i = 0; i < 6; i++){
          lString.add(splittedString[i]);
        }
        lString.forEach((e) => hString += e);
      }
      
      

      print(hString);
      double h = double.parse(hString);
      double p = solusiIdealPurpose[index];
      double b = solusiIdealBahan[index];
      double unSqrt = quadratic(h - aPlusHarga) + quadratic(p - aPlusPurpose) + quadratic(b - aPlusBahan);
      double dResult = sqrt(unSqrt);
      return {"uid": availableData[index].uid, "dPlus": dResult};
    });

    List.generate(d.length, (index){
      double dMin = sqrt(quadratic(solusiIdealHarga[index] - aMinHarga) + quadratic(solusiIdealPurpose[index] - aMinPurpose) + quadratic(solusiIdealBahan[index] - aMinBahan));
      d[index].addAll({"dMin": dMin});
    });

    List.generate(d.length, (index) {
      double v = d[index]['dPlus'] / (d[index]['dPlus'] + d[index]['dMin']);
      d[index].addAll({"v": v});
    });

    for(int i = 0; i < availableData.length; i++){
      availableData[i].rate = d[i]['v'];
    }

    availableData.sort((a,b) => a.rate!.compareTo(b.rate!));

    sepatuResult = availableData;


    return sepatuResult;
  }

  double quadratic(a){
    return a*a;
  }

}

main(){
  print("Sistem Pendukung Keputusan; Kelompok 9;\nFilza Hisana : NIM 20051397018;\nMuch Kholiqul Rosidin : NIM 20051397058;\nFahmi Fahqur Rozi : NIM 20051397060;");
  print("Mencari Rekomendasi Sepatu");
  print("");
  print("Masukkan Range Harga yang anda inginkan (contoh 750000) ");
  print("Harga Pertama : ");
  String? harga = stdin.readLineSync(encoding: utf8);
  print("Harga Kedua : ");
  String? harga2 = stdin.readLineSync(encoding: utf8);
  List<int> rangeHarga = [int.parse(harga ?? "0"), int.parse(harga2 ?? "5000000")];
  bool isPurposeOk= false;
  List<String> purpose = [];
  while(isPurposeOk == false){
    print("Anda ingin sepatu yang bisa digunakan untuk apa ? ");
    purpose.add(stdin.readLineSync(encoding: utf8) ?? "");
    print("Apakah anda ingin menambahkan lagi?");
    String sts = stdin.readLineSync(encoding: utf8) ?? "N";
    if(sts == "Y" || sts == "y"){
      isPurposeOk = false;
    }else{
      isPurposeOk = true;
    }
  }

  bool isBahanOk = false;
  List<String> bahan = [];
  while(isBahanOk == false){
    print("Anda ingin sepatu yang berbahan apa ? ");
    bahan.add(stdin.readLineSync(encoding: utf8) ?? "");
    print("Apakah anda ingin menambahkan lagi?");
    String status = stdin.readLineSync(encoding: utf8) ?? "N";
    if(status == "Y" || status == "y"){
      isBahanOk = false;
    }else{
      isBahanOk = true;
    }
  }
  List<Sepatu> sepatu = Topsis(harga: [int.parse(harga ?? "0"), int.parse(harga2 ?? "5000000")], purpose: purpose, bahan: bahan).getResult();
  print("Menampilkan 5 data sepatu yang cocok untuk kamu");
  print("");
  sepatu.sort((a, b) => a.rate!.compareTo(b.rate!));
  List<Sepatu> result = (sepatu.reversed).toList();
  for(int i = 0; i < 6; i++){
    print("Tipe sepatu: ${result[i].name}");
    print("Merk: ${result[i].merk}");
    print("Bahan: ${result[i].bahan.toString()}");
    print("Harga: ${result[i].harga.toString()}");
    print("Kegunaan: ${result[i].purpose.toString()}");
  }
}