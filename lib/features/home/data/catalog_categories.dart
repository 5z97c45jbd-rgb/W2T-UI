abstract final class CatalogCategories {
  static String apiValue(String label) {
    switch (label.trim().toLowerCase()) {
      case 'food':
        return 'FOOD';
      case 'grocery':
      case 'groceries':
        return 'GROCERIES';
      case 'individuals':
      case 'individual':
        return 'INDIVIDUALS';
      case 'electronics':
        return 'ELECTRONICS';
      case 'fashion':
        return 'FASHION';
      case 'pet care':
        return 'PET_CARE';
      case 'self talent':
        return 'SELF_TALENT';
      case 'child care':
        return 'CHILD_CARE';
      default:
        return label.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '_');
    }
  }
}
