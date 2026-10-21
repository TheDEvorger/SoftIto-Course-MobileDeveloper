/// Filo simülasyon rolleri (Görüntüleyici: salt-okunur, Operatör: işlem yapabilir, Yönetici: tam yetki)
enum FleetDemoRole { viewer, operator, manager }

/// Filo araç durumu (Müsait veya Bakımda)
enum FleetVehicleStatus { available, maintenance }

/// Örnek kurumsal filo organizasyonları
const demoOrganizations = {
  'north': 'Örnek Kuzey Filo',
  'south': 'Örnek Güney Filo'
};

/// Örnek şube tanımları (Organizasyon Kimliği, Şube Adı)
const demoBranches = {
  'north-center': ('north', 'Örnek Merkez'),
  'north-west': ('north', 'Örnek Batı'),
  'south-center': ('south', 'Örnek Güney Merkez'),
};

/// Filoya ait araç modeli
class FleetVehicle {
  const FleetVehicle(this.id, this.organizationId, this.branchId, this.name,
      {this.status = FleetVehicleStatus.available});

  /// Araç kimliği
  final String id;

  /// Ait olduğu organizasyon
  final String organizationId;

  /// Ait olduğu şube
  final String branchId;

  /// Araç adı
  final String name;

  /// Bakım / uygunluk durumu
  final FleetVehicleStatus status;

  /// Durumu güncellenmiş yeni araç örneği oluşturur
  FleetVehicle withStatus(FleetVehicleStatus value) =>
      FleetVehicle(id, organizationId, branchId, name, status: value);
}

/// Çoklu kiracılı (multi-tenant) filo çalışma alanı yönetim sınıfı.
/// Organizasyon, şube ve rol simülasyonunu yönetir.
class DemoFleetWorkspace {
  String _organizationId = 'north';
  String? _branchId;
  FleetDemoRole _role = FleetDemoRole.viewer;
  final List<FleetVehicle> _vehicles = [
    const FleetVehicle('fleet-1', 'north', 'north-center', 'Executive S'),
    const FleetVehicle('fleet-2', 'north', 'north-west', 'Grand Tourer'),
    const FleetVehicle('fleet-3', 'south', 'south-center', 'Urban E'),
  ];
  String get organizationId => _organizationId;
  String? get branchId => _branchId;
  FleetDemoRole get role => _role;
  bool get canEdit => _role != FleetDemoRole.viewer;
  List<FleetVehicle> get visibleVehicles => List.unmodifiable(_vehicles.where(
      (v) =>
          v.organizationId == _organizationId &&
          (_branchId == null || v.branchId == _branchId)));

  void selectOrganization(String id) {
    if (!demoOrganizations.containsKey(id)) {
      throw ArgumentError('Bilinmeyen örnek filo.');
    }
    _organizationId = id;
    _branchId = null;
    _role = FleetDemoRole.viewer;
  }

  void selectBranch(String? id) {
    if (id != null && demoBranches[id]?.$1 != _organizationId) {
      throw ArgumentError('Şube bu örnek filoya ait değil.');
    }
    _branchId = id;
  }

  void selectDemoRole(FleetDemoRole role) => _role = role;

  void toggleMaintenance(String id) {
    if (!canEdit) throw StateError('Görüntüleyici demo verisini değiştiremez.');
    final index = _vehicles.indexWhere((v) =>
        v.id == id &&
        v.organizationId == _organizationId &&
        (_branchId == null || v.branchId == _branchId));
    if (index < 0) throw StateError('Araç seçili filo/şube bağlamında değil.');
    final vehicle = _vehicles[index];
    _vehicles[index] = vehicle.withStatus(
        vehicle.status == FleetVehicleStatus.available
            ? FleetVehicleStatus.maintenance
            : FleetVehicleStatus.available);
  }
}
