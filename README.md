# HungerGames
An adventure game built in Prolog

=====Penting=====
untuk penggunaan nama konstanta yang memiliki spasi wajib menggunakan ' (petik)

misal : take('canned soup').

=====Cara Penggunaan======
pada awal permainan hanya dapat menggunakan start\0 atau loadGame\1

fungsi 'start\0'

~ digunakan untuk memulai permainan

contoh:
> start.

fungsi 'loadGame\1'

~ digunakan untuk men-load data yang telah di-save

loadGame(NamaFile).
NamaFile harus diberi petik
Misal : 'save.txt'

contoh:
> loadGame('save.txt').

fungsi 'save\1'

~ digunakan untuk menyimpan data game saat ini.

save(NamaFile), Sama seperti loadGame. Nama dari namafile harus pakai ' (petik)

contoh:
> save('save.txt').

--> dengan NamaFile merupakan nama file yang menyimpan data yang sebelumnya telah di-save atau yang mau di-save

fungsi 'w/e/s/n\0'.

~ digunakan untuk pergerakan (untuk lebih lengkapnya bisa dilihat di laporan)

contoh:
> w.

fungsi 'use\1'

~ digunakan untuk menggunakan sesuatu

contoh:
> use(apple)

fungsi 'take\1'

~ digunakan untuk mengambil sesuatu di tanah

contoh:
> take(apple).

fungsi 'drop\1'

~ digunakan untuk membuang barang yang ada diinventori ke tanah

contoh:
> drop(apple).

fungsi 'status\0'

~ digunakan untuk melihat status pemain

contoh :
> status.

fungsi 'attack\0'

~ digunakan untuk menyerang musuh namun harus dengan senjata yang telah diuse sebelumbya (use senjata tidak perlu setiap mau menyerang asalkan sudah ada senjata yang pernah diuse penyerangan sudah bisa dilakukan)

contoh:
> attack.

fungsi 'map\0'

~ digunakan untuk melihat peta namun harus memiliki radar di inventory

contoh:
> map.

fungsi 'look\0'

~ digunakan untuk melihat sekitar

contoh:
> look.

fungsi 'surrender\0'

~ digunakan untuk menyetah dan 'auto lose' permainan

contoh:
> surrender.

fungsi 'makedonut\0'

~ digunakan untuk membuat donat namun pembuatan hanya bisa di kampus dan mengurangi thrist sebesar 10 poin.

contoh:
> makedonut.

fungsi 'quit\0'

~ digunakan untuk keluar dari program

contoh:
> quit.

=====Eksekusi Program====
Penjalanan program dapat dilakukan pada OS apapun asalakan support gnu prolog (sejauh ini saya tau OS yang support adalah, windows, macOs dan linux).

Program dapat dijalankan dengan 'mendouble click' file atau lewat 'consult' file.
