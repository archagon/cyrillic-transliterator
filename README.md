# Cyrillic Transliterator

This set of apps allows you to type Latin characters in OSX and have them transliterate in real time into Cyrillic characters. This includes multi-character transliterations like 'sh'/'ш'.

![Demo](Demo.gif)

## Background

I'm Russian and I frequently have to type using the Cyrillic alphabet. Unfortunately, even after several years, I just can't get the hang of the native Russian keyboard layout. It's far too frustrating to peck out paragraphs one letter at a time when you can speed through English text at 100 words per minute!

A few years ago, a friend pointed me to the website [Translit.ru][1], and I discovered that I can suddenly type in Russian almost as fast as I can in English. The trick is that almost every character in the Cyrillic alphabet has a simple transliteration at most three characters long; for example, 'я' is 'ya', and 'ш' is 'sh'. All you have to do is type the transliterated Russian text into Translit and it spits out the Russian for you as you go.

Recently, I've been getting frustrated that I had to open my browser, go to some website, and then copy text whenever I wanted to type something in Russian. Why couldn't I do it natively from my OS? True, OSX had a built-in phonetic Russian keyboard, but it was flawed; since each key only mapped to a single transliterated key, it only worked as long as the Latin letter sounded like the Cyrillic one. Letters like 'я' ('ya') ended up mapped to completely irrelevant letters ('q').

So after a bit of research, I started working on a couple of solutions. The first one I finished was an input method, and it works almost exactly like the website — only natively, right inside my OS!

## Techniques

Transliteration can be done in one of four ways. (At the moment, only one is functional.)

### Input Method

OSX has native [input method][2] support, typically for complicated character input like Chinese or Hebrew. The advantage of this method is that the transliterated keyboard shows up with all your other keyboards in your menu bar and behaves as expected with all text fields. To install, copy the input method app into your `~/Library/Input Methods` directory and select the "Cyrillic Transliterator" keyboard from the Russian section.

### Menu Bar App (WIP)

This app runs in the menu bar and transliterates text based on Quartz event taps. Behavior is not as predictable as with the input method approach, since the app has no way of knowing if the user is typing into a text box. Accesibility has to be turned on for this app. Since dealing with input methods can be a little messy, this app is intended for users who would feel more safe with a stand-alone app.

### Sandboxed Text Box App (WIP)

Intended for Mac App Store release, this app presents a simple text box that the user can type text into and then manually copy the transliteration from. The app can also transliterate pasted text.

### Service (WIP)

In addition to the real-time transliteration support provided by the apps above, you can also transliterate selected text via Services. This can be bound to a key command in OSX settings.

---

The demo animation was created by using [LICEcap][3] to capture the OSX on-screen keyboard over a TextEdit window.

[1]: http://www.translit.ru
[2]: http://en.wikipedia.org/wiki/Input_method
[3]: http://www.cockos.com/licecap/