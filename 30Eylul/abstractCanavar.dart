abstract class Canavar {
  void kukre();
}

class Kurt extends Canavar {
  @override
  void kukre() {
    print("Kurt: Auuuuuuu! ");
  }
}

class Ejderha extends Canavar {
  @override
  void kukre() {
    print("Ejderha: ağğğğğğğğğğğ! ");
  }
}

class Aslan extends Canavar {
  @override
  void kukre() {
    print("Aslan: harrrrrrrrr! ");
  }
}

void main() {
  final karaOrmanKurdu = Kurt();
  final ejderha = Ejderha();
  final vahsiAslan = Aslan();

  karaOrmanKurdu.kukre();
  ejderha.kukre();
  vahsiAslan.kukre();
}