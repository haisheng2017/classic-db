-- Lorekeeper Polkelt (10901) does not answer trash call-for-help.
-- CREATURE_EXTRA_FLAG_NO_RESPOND_ASSIST = 0x00040000 (262144)
UPDATE `creature_template` SET `ExtraFlags` = `ExtraFlags` | 262144 WHERE `entry` = 10901;
