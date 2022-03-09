

####Bubble menu picker
<img src="https://github.com/isaacselement/flutter_dialog_shower/raw/master/example/images/demo_bubble.png" width="50%" height="50%" alt="" align=center />

####Alert with icon
<img src="https://github.com/isaacselement/flutter_dialog_shower/raw/master/example/images/demo_alert.png" width="50%" height="50%" alt="" align=center />

####Loading
<img src="https://github.com/isaacselement/flutter_dialog_shower/raw/master/example/images/demo_loading.png" width="50%" height="50%" alt="" align=center />



#DialogShower

####Simple to use

```
DialogShower.init(context);  # init with a root context in your app
    
```

```
DialogShower shower = DialogShower()
..build()
..barrierDismissible = true
..containerShadowColor = Colors.grey
..containerShadowBlurRadius = 50.0
..containerBorderRadius = 5.0
..show(__your_widget_here__);
```


#Brother

#### Update by key for decoupling


```
BtKey updateWidgetsKey = BtKey();

String text = 'You are some handsome';

@override
Widget build(BuildContext context) {
updateWidgetsKey.eye; // Put an eye here. Dota/LOL online game 插个眼.
return InkWell(
  child: Text(text),
  onTap: () {
    List<String> v = ['❗️', '🔴', '👠', '⌘', '🏁', '咳', 'か', 'нг', 'зз'];
    text = (v..shuffle()).first;
    updateWidgetsKey.update();  // when text update, call eye update :)
  },
);
}
```



### Update by value


```
Btv<String> text = 'You are so awesome'.btv;

@override
Widget build(BuildContext context) {
return InkWell(
  child: Text(text.value),
  onTap: () {
    List<String> v = ['Niu', 'Ok', 'Six', 'Wa', 'Ha', 'WooLa'];
    text.value = (v..shuffle()).first;
  },
);
}
```


