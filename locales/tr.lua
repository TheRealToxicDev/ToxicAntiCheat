Locales['tr'] = {
    -- Name
    ['name'] = 'TigoAntiHile',

    -- General
    ['unknown'] = 'bilinmeyen',
    ['fatal_error'] = 'FATAL HATA',

    -- Resource strings
    ['callback_not_found'] = '[%s] bulunamadi',
    ['trigger_not_found'] = '[%s] bulunamadi',

    -- Ban strings
    ['checking'] = '👮 ToxicAntiCheat | Şu anda kontrol ediliyorsunuz...',
    ['user_ban_reason'] = '👮 ToxicAntiCheat | Bu sunucudan banlandin ( Isim: %s )',
    ['user_kick_reason'] = '👮 ToxicAntiCheat | Sunucudan atildin ( Sebep: %s )',
    ['banlist_ban_reason'] = 'Oyuncu bu eventi triggerlamaya calisti \'%s\' event',
    ['banlist_not_loaded_kick_player'] = '👮 ToxicAntiCheat | Banlar yuklenemedi, Birkac saniye beklemek zorundasin. Daha sonra dene!',
    ['ip_not_found'] = '👮 ToxicAntiCheat | IP\'nizi bulamadık',
    ['ip_blocked'] = '👮 ToxicAntiCheat | Etkin bir VPN\'niz var, sunucuya katılmak için devre dışı bırakın | Yanlış? Sunucu sahipleriyle iletişim kurun',
    ['new_identifiers_found'] = '%s, yeni identifier(lar) bulundu - orijinal ban %s',
    ['failed_to_load_banlist'] = '[ToxicAntiCheat] Ban listesi yuklenemedi!',
    ['failed_to_load_tokenlist'] = '[ToxicAntiCheat] Token listesi yuklenemedi!',
    ['failed_to_load_ips'] = '[ToxicAntiCheat] IPs listesi yuklenemedi!',
    ['failed_to_load_check'] = '[ToxicAntiCheat] Bu hatayi duzeltmelisin, Banlar CALISMAYACAK!',
    ['ban_type_godmode'] = 'Oyuncuda godmode tespit edildi',
    ['lua_executor_found'] = 'Oyuncuda lua executor tespit edildi',
    ['ban_type_injection'] = 'Oyuncu oyuna komut ekledi (Enjekte)',
    ['ban_type_blacklisted_weapon'] = 'Oyuncu blacklistlenmis silah aldi: %s',
    ['ban_type_blacklisted_key'] = 'Oyuncu blacklistli bir tusa basti %s',
    ['ban_type_hash'] = 'Oyuncu hash degistirdi',
    ['ban_type_esx_shared'] = 'Oyuncu sunu triggerlamaya calisti: \'esx:getSharedObject\'',
    ['ban_type_superjump'] = 'Oyuncu ziplama yuksekligini degistirdi',
    ['ban_type_client_files_blocked'] = 'Oyuncu canli olup olmadigini 5 saniye boyunca belirtmedi (Client Dosyalari Engellendi)',
    ['kick_type_security_token'] = 'Cunku sana ozel bir token olusturamayiz.',
    ['kick_type_security_mismatch'] = 'Cunku ozel tokenin eslesmedi',

    -- Commands
    ['command'] = 'Komut',
    ['available_commands'] = 'Mevcut Komutlar ',
    ['command_reload'] = 'Ban listesini yeniden yukle',
    ['ips_command_reload'] = 'IPs listesini yeniden yukle',
    ['ips_command_add'] = 'Beyaz listeye eklenen IP\'ler listesine IP ekleyin',
    ['command_help'] = 'Tum antihile komutlarini dondurur',
    ['command_total'] = 'Toplam ban sayisini dondurur',
    ['total_bans'] = 'Su anda listede %s adet ban var',
    ['command_not_found'] = 'yok',
    ['banlist_reloaded'] = 'Tum banlar banlist.json dosyasindan geri yuklendi.',
    ['ips_reloaded'] = 'Tüm IP\'ler ignore-ips.json sitesinden yeniden yüklendi',
    ['ip_added'] = 'IP:% s, beyaz listeye eklendi',
    ['ip_invalid'] = 'IP:% s, geçerli bir IP değil, şöyle görünmelidir, örneğin: 0.0.0.0',
    ['not_allowed'] = 'Bunu calistirmak icin iznin yok %s',

    -- Discord
    ['discord_title'] = '[ToxicAntiCheat] Bir oyuncuyu banladi',
    ['discord_description'] = '**Isim:** %s\n **Sebep:** %s\n **Kimlikler:**\n %s'
}