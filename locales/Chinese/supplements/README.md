# 中文 locale 补充包（zhCN / loc4）

对照 Classic 英文 `Full_DB` 与现有 `locales/Chinese/locales_*.sql`，补缺并纠正仍为英文的字段。
**不修改** 原文 `locales_*.sql`；本目录可单独导入。

## 文件

| 文件 | 表 | 说明 |
|---|---|---|
| `01_locales_quest_zhCN_fixup.sql` | `locales_quest` | 缺失任务 |
| `02_locales_creature_zhCN_fixup.sql` | `locales_creature` | 缺失 + 名称/头衔仍为英文 |
| `03_locales_item_zhCN_fixup.sql` | `locales_item` | 缺失 + 名称/描述仍为英文 |
| `04_locales_gameobject_zhCN_fixup.sql` | `locales_gameobject` | 缺失 + 名称仍为英文 |
| `05_locales_page_text_zhCN_fixup.sql` | `locales_page_text` | 可汉化的书页文本 |

每条均为：

```sql
INSERT INTO locales_* (...) VALUES (...)
ON DUPLICATE KEY UPDATE ..._loc4=VALUES(..._loc4);
```

## 导入方式

`InstallFullDB.sh` 的 `LOCALES=YES` **只扫描** `locales/*.sql` 顶层，**不会**自动导入 `locales/Chinese/` 或其 `supplements/`。

在已导入主库与（可选）顶层 locale 之后，按序手工执行（库名/账号按本机 `InstallFullDB.config`）：

```bash
mysql classicmangos < locales/Chinese/supplements/01_locales_quest_zhCN_fixup.sql
mysql classicmangos < locales/Chinese/supplements/02_locales_creature_zhCN_fixup.sql
mysql classicmangos < locales/Chinese/supplements/03_locales_item_zhCN_fixup.sql
mysql classicmangos < locales/Chinese/supplements/04_locales_gameobject_zhCN_fixup.sql
mysql classicmangos < locales/Chinese/supplements/05_locales_page_text_zhCN_fixup.sql
```

Windows / 已登录客户端示例（在 classic-db 仓库根目录下）：

```sql
SOURCE locales/Chinese/supplements/01_locales_quest_zhCN_fixup.sql;
-- …其余四组
```

导入后重启 world 进程或 `.reload` 相关表（视核心版本），用中文客户端确认任务 707 等已显示中文。

## 判定规则（写入本包的行）

1. **缺失**：英文源有非空展示文本，中文 locale 无该 `entry`
2. **错误/未译**：中文行存在，但对应字段仍基本是英文（拉丁字母为主、无汉字）
3. **已知空洞**：如任务 707（原中文包在 706→709 跳号）

**不碰**：已是中文且语义大致对应的既有译文。

书页中纯 HTML 配图、`Missing WDB data` 等无中文语义的占位不强制汉化。

## 与 InstallFullDB / 主中文包的关系

- 主中文文件仍在 `locales/Chinese/locales_*.sql`，需自行 `SOURCE` 或复制到顶层再被 `LOCALES=YES` 扫到。
- 本补充包是**增量补丁**，应在主中文包之后导入；`ON DUPLICATE KEY UPDATE` 会覆盖同 entry 的 loc4 字段。
- 若任务/NPC/物品仍显示英文：先确认客户端语言与 `locales_*` 的 loc4 已写入，再查本包是否覆盖该 entry。

## 译文来源与风格

- 主体对齐 [DecadeWoW/wow_db_chinese](https://github.com/DecadeWoW/wow_db_chinese)（CMaNGOS Classic 社区汉化），按 `entry` 匹配。
- 专有名尽量与现有中文包一致（如：勘察员基恩萨·铁环、洛克莫丹、铁环挖掘场）。
- 保留 `$N` / `$B` / `$C` / `$R` / `$G` 等占位符。
- 对参考库亦无可靠中文的 `Deprecated` / `UNUSED` / `OLD` / `TEST` 等内部用名，添加「废弃：」「未使用」「旧版」「测试」「（未译）」等前缀，避免界面残留纯英文。
