const String defaultAssetPath = 'assets/images/default.png';

const Map<String, String> supportedAssetPaths = {
  'default': defaultAssetPath,
  'promo': 'assets/images/promo.png',
};

class PayloadDecision {
  const PayloadDecision.accepted(this.assetPath) : diagnostic = null;

  const PayloadDecision.rejected(this.diagnostic) : assetPath = null;

  final String? assetPath;
  final String? diagnostic;

  bool get isAccepted => assetPath != null;
}

PayloadDecision validatePayload(Map<String, dynamic> data) {
  if (data['action'] != 'update_ui') {
    return const PayloadDecision.rejected(
      'Rejected payload: action must be update_ui.',
    );
  }

  final assetPath = supportedAssetPaths[data['asset']];
  if (assetPath == null) {
    return const PayloadDecision.rejected(
      'Rejected payload: asset must be default or promo.',
    );
  }

  return PayloadDecision.accepted(assetPath);
}
