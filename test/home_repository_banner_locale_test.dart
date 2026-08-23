import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/utils/currency_formatter.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/features/home/repositories/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('promo banner endpoint resolves the active locale-specific banner set', () {
    expect(HomeRepository.resolvePromoBannerEndpoint('en'), ApiEndpoints.appBanners);
    expect(HomeRepository.resolvePromoBannerEndpoint('ar'), ApiEndpoints.appBannersAr);
    expect(HomeRepository.resolvePromoBannerEndpoint('ar-SA'), ApiEndpoints.appBannersAr);
    expect(HomeRepository.resolvePromoBannerEndpoint(null), ApiEndpoints.appBanners);
    expect(HomeRepository.resolvePromoBannerEndpoint(''), ApiEndpoints.appBanners);
  });

  test('promo banner target route is parsed from the backend payload', () {
    final banner = HomeBannerModel.fromJson({
      'image': 'https://example.com/banner.png',
      'targetScreen': 'communities',
    });

    expect(banner.targetScreen, 'communities');
  });

  test('currency formatter resolves the actual symbol from the provided currency code', () {
    expect(resolveCurrencySymbol('AED'), '');
    expect(resolveCurrencySymbol('USD'), '\$');
    expect(formatPriceWithCurrency(1250, 'AED'), '1250');
    expect(formatPriceWithCurrency(1250, 'USD'), '1250 \$');
  });
}
