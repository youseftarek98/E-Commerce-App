
import 'package:e_commerce_clean/app/extensions.dart';

import '../../app/constants.dart';
import '../../domain/model/models.dart';
import '../response/responses.dart';

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(
        this?.id?.orEmpty() ?? Constants.empty,
        this?.name?.orEmpty() ?? Constants.empty,
        this?.numOfNotification?.orZero() ?? Constants.zero);
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomain() {
    return Contacts(
        this?.phone.orEmpty() ?? Constants.empty,
        this?.email.orEmpty() ?? Constants.empty,
        this?.link.orEmpty() ?? Constants.empty);
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomain() {
    return Authentication(
      this?.customer.toDomain(),
      this?.contacts.toDomain(),
    );
  }
}

extension ServiceResponseMapper on ServiceResponse? {
  Service toDomain() {
    return Service(
        this?.id.orZero() ?? Constants.zero,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty);
  }
}

extension StoreResponseMapper on StoresResponse? {
  Store toDomain() {
    return Store(
        this?.id.orZero() ?? Constants.zero,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty);
  }
}

extension BannersResponseMapper on BannersResponse? {
  BannerAd toDomain() {
    return BannerAd(
        this?.id.orZero() ?? Constants.zero,
        this?.link.orEmpty() ?? Constants.empty,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty);
  }
}

extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomain() {
    List<Service> services = (this
                ?.data
                ?.services
                ?.map((serviceResponse) => serviceResponse.toDomain()) ??
            const Iterable.empty())
        .cast<Service>()
        .toList();

    List<BannerAd> banners = (this
                ?.data
                ?.banners
                ?.map((bannersResponse) => bannersResponse.toDomain()) ??
            const Iterable.empty())
        .cast<BannerAd>()
        .toList();

    List<Store> stores = (this
                ?.data
                ?.stores
                ?.map((storesResponse) => storesResponse.toDomain()) ??
            const Iterable.empty())
        .cast<Store>()
        .toList();

    var data = HomeData(services, banners, stores);
    return HomeObject(data);
  }
}
