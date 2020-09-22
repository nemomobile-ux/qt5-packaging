# Qt packaging for Nemo

Qt packages for Nemo are based on Fedora packages with adjustments for
the mobile platform. At the moment of writing, it is disabling GL and
enabling GLESv2 instead.

The included script allows to fetch Qt packages from Fedora source
RPMS, patch them, and prepare for upload to OBS.

To use:

1. Checkout OBS repository:

```
osc co home:neochapay:nemo:qt
```

2. Clone this repository

```
git clone https://github.com/nemomobile-ux/qt5-packaging.git
```

3. Go to checked out OBS repository and run the script for Qt updates:

```
cd home\:neochapay\:nemo\:qt
../qt5-packaging/qt-updater.sh
```

This will create directory `packages`, download all Qt5 packages from
the mirror, patch them, and run `osc ar` for all the packages. To
update at OBS, run

```
osc commit -m update
```
