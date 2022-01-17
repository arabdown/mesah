import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  _ProductDetailState createState() {
    return _ProductDetailState();
  }
}

class _ProductDetailState extends State<ProductDetail> {
  final _scrollController = ScrollController();
  final _productDetailCubit = ProductDetailCubit();
  late StreamSubscription _reviewSubscription;

  Color? _iconColor = Colors.white;
  bool _showHour = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _productDetailCubit.onLoad(widget.id);
    _reviewSubscription = AppBloc.reviewCubit.stream.listen((state) {
      if (state is ReviewSuccess && state.id != null && state.id == widget.id) {
        _productDetailCubit.onLoad(widget.id);
      }
    });
  }

  @override
  void dispose() {
    _reviewSubscription.cancel();
    _productDetailCubit.close();
    _scrollController.dispose();
    super.dispose();
  }

  ///Handle icon theme
  void _onScroll() {
    Color? color;
    if (_scrollController.position.extentBefore < 110) {
      color = Colors.white;
    }
    if (color != _iconColor) {
      setState(() {
        _iconColor = color;
      });
    }
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item.id);
  }

  ///On Preview Profile
  void _onProfile(UserModel user) {
    Navigator.pushNamed(context, Routes.profile, arguments: user);
  }

  ///On navigate map
  void _onLocation(ProductModel item) {
    Navigator.pushNamed(
      context,
      Routes.location,
      arguments: item.location,
    );
  }

  ///On show message fail
  void _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('explore_product'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context).translate('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              type: ButtonType.text,
            ),
          ],
        );
      },
    );
  }

  ///On Share
  void _onShare(ProductModel item) {
    Share.share(
      'Check out my item ${item.link}',
      subject: 'PassionUI',
    );
  }

  ///On navigate gallery
  void _onPhotoPreview(ProductModel item) {
    if (item.galleries.isEmpty) {
      _showMessage(Translate.of(context).translate("galleries_empty"));
    } else {
      Navigator.pushNamed(
        context,
        Routes.gallery,
        arguments: item,
      );
    }
  }

  ///On navigate review
  void _onReview(ProductModel product) async {
    if (AppBloc.userCubit.state == null) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.productDetail,
      );
      if (result != Routes.productDetail) return;
    }

    Navigator.pushNamed(
      context,
      Routes.review,
      arguments: product,
    );
  }

  ///On like product
  void _onFavorite() async {
    if (AppBloc.userCubit.state == null) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.productDetail,
      );
      if (result != Routes.productDetail) return;
    }
    _productDetailCubit.onFavorite();
  }

  ///Make action
  void _makeAction(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showMessage(Translate.of(context).translate('cannot_make_action'));
    }
  }

  ///Build content UI
  Widget _buildContent(ProductModel? product) {
    ///Build UI loading
    List<Widget> action = [];
    Widget background = AppPlaceholder(
      child: Container(
        color: Colors.white,
      ),
    );
    Widget phone = Container();
    Widget fax = Container();
    Widget email = Container();
    Widget website = Container();
    Widget openHours = Container();
    Widget dateAndPrice = Container();
    Widget info = AppPlaceholder(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              height: 16,
              width: 150,
              color: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 16,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 20,
                      width: 150,
                      color: Colors.white,
                    ),
                  ],
                ),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 200,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 200,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 200,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 200,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 200,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
          ],
        ),
      ),
    );
    Widget status = Container();
    Widget feature = AppPlaceholder(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 10, color: Colors.white),
          ],
        ),
      ),
    );
    Widget related = Container();
    String currency = ListSetting.unit;

    ///UX change action color
    IconThemeData iconTheme = Theme.of(context).iconTheme;
    if (_iconColor != null) {
      iconTheme = Theme.of(context).iconTheme.copyWith(color: _iconColor);
    }

    /// Build Detail
    if (product != null) {
      if (product.status.isNotEmpty) {
        status = AppTag(
          product.status,
          type: TagType.status,
        );
      }
      if (product.lastest.isNotEmpty) {
        feature = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                Translate.of(context).translate('featured'),
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final ProductModel item = product.lastest[index];
                  return Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AppProductItem(
                      onPressed: () {
                        _onProductDetail(item);
                      },
                      item: item,
                      type: ProductViewType.gird,
                    ),
                  );
                },
                itemCount: product.lastest.length,
              ),
            )
          ],
        );
      }
      if (product.related.isNotEmpty) {
        related = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Translate.of(context).translate('related'),
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final item = product.related[index];
                  return AppProductItem(
                    onPressed: () {
                      _onProductDetail(item);
                    },
                    item: item,
                    type: ProductViewType.small,
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  );
                },
                itemCount: product.related.length,
              ),
            ],
          ),
        );
      }

      ///BackgroundIcon
      Color? backgroundIcon;
      if (_iconColor == Colors.white) {
        backgroundIcon = Colors.grey.withOpacity(0.3);
      }

      ///Action
      action = [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundIcon,
          ),
          child: IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              _onShare(product);
            },
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundIcon,
          ),
          child: IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              _onLocation(product);
            },
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundIcon,
          ),
          child: IconButton(
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: () {
              _onPhotoPreview(product);
            },
          ),
        ),
        const SizedBox(width: 8),
      ];

      ///Background
      background = CachedNetworkImage(
        imageUrl: product.image.full,
        placeholder: (context, url) {
          return AppPlaceholder(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          );
        },
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return AppPlaceholder(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: const Icon(Icons.error),
            ),
          );
        },
      );

      ///phone
      if (product.phone.isNotEmpty) {
        phone = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _makeAction('tel:${product.phone}');
              },
              child: Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor,
                    ),
                    child: const Icon(
                      Icons.phone_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate('phone'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          product.phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }

      ///Fax
      if (product.fax.isNotEmpty) {
        fax = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _makeAction('tel:${product.fax}');
              },
              child: Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor,
                    ),
                    child: const Icon(
                      Icons.perm_phone_msg_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate('fax'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          product.fax,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }

      ///Email
      if (product.email.isNotEmpty) {
        email = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _makeAction('mailto:${product.email}');
              },
              child: Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor,
                    ),
                    child: const Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate('email'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          product.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }

      ///Website
      if (product.website.isNotEmpty) {
        website = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _makeAction(product.website);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor,
                    ),
                    child: const Icon(
                      Icons.language_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate('website'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          product.website,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }

      ///Open hours
      if (product.openHours.isNotEmpty) {
        openHours = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() {
                  _showHour = !_showHour;
                });
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).dividerColor,
                          ),
                          child: const Icon(
                            Icons.access_time_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Translate.of(context).translate('open_time'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _showHour
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  )
                ],
              ),
            ),
            Visibility(
              visible: _showHour,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product.openHours.map((item) {
                  final hour = item.schedule
                      .map((e) {
                        return '${e.start.viewTime}-${e.end.viewTime}';
                      })
                      .toList()
                      .join(",");
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 42),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate(item.key),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hour,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }

      ///Date and Price
      if (product.dateEstablish.isNotEmpty || product.priceMin != 0) {
        Widget dateEstablish = Container();
        Widget priceRange = Container();
        if (product.dateEstablish.isNotEmpty) {
          dateEstablish = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Translate.of(context).translate(
                  'date_established',
                ),
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: 4),
              Text(
                product.dateEstablish,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontWeight: FontWeight.bold),
              )
            ],
          );
        }
        if (product.priceMin != 0) {
          priceRange = Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                Translate.of(context).translate('price_range'),
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: 4),
              Text(
                "$currency ${product.priceMin} - ${product.priceMax} $currency",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontWeight: FontWeight.bold),
              )
            ],
          );
        }
        dateAndPrice = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dateEstablish,
                priceRange,
              ],
            ),
          ],
        );
      }

      ///Info
      info = Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    product.title,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    product.favorite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: _onFavorite,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.category!.title,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () {
                        _onReview(product);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AppTag(
                            "${product.rate}",
                            type: TagType.rate,
                          ),
                          const SizedBox(width: 4),
                          RatingBar.builder(
                            initialRating: product.rate,
                            unratedColor: Colors.amber.withAlpha(100),
                            itemCount: 5,
                            itemSize: 14.0,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rate) {},
                            ignoreGestures: true,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "(${product.numRate})",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                status,
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _makeAction(
                  'https://www.google.com/maps/search/?api=1&query=${product.location!.latitude},${product.location!.longitude}',
                );
              },
              child: Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor,
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Translate.of(context).translate('address'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          product.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            phone,
            fax,
            email,
            website,
            openHours,
            const SizedBox(height: 16),
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    height: 1.3,
                  ),
            ),
            dateAndPrice,
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Translate.of(context).translate('facilities'),
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: product.features.map((item) {
                    return IntrinsicWidth(
                      child: AppTag(
                        item.title,
                        type: TagType.chip,
                        icon: Icon(
                          item.icon,
                          size: 10,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],
            )
          ],
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 200.0,
          pinned: true,
          actions: action,
          iconTheme: iconTheme,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.none,
            background: background,
          ),
        ),
        SliverToBoxAdapter(
          child: SafeArea(
            top: false,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppUserInfo(
                    user: product?.author,
                    type: UserViewType.basic,
                    onPressed: () {
                      _onProfile(product!.author!);
                    },
                  ),
                ),
                info,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(),
                ),
                feature,
                const SizedBox(height: 8),
                related,
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _productDetailCubit,
      child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          ProductModel? product;
          if (state is ProductDetailSuccess) {
            product = state.product;
          }
          return Scaffold(
            body: _buildContent(product),
          );
        },
      ),
    );
  }
}
