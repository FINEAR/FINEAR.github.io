# 博客使用说明（Hugh's notes / cxh.net.cn）

> 本文件由 DSH 于 2026-10-04 体检后生成。记录博客现状、日常更新流程和已知问题。
> 2026-10-04 更新：已修复 `url` 为 https、为文章补上固定日期、GitHub SSH 密钥、Vercel 构建失败（Node 18→24）、公式与表格滚动条、MathJax 加载 CDN；评论从 Valine 切到 Giscus；关闭已失效的访客统计；发布技术笔记三篇（DMFT 入门、洪特耦合与洪特金属、三轨道原子极限与两面神效应）。
> 2026-10-06 更新：给《三轨道原子极限与洪特金属的两面神效应》补了一节附录——从 Kanamori 五项完整推导 N、S、L 形式的原子极限哈密顿量（含系数对照表、线性项为何可以丢掉、Slater/Racah 关系的来源，以及 Dworin–Narath 形式的对照）。该文参考文献也补到 10 条。
> 2026-10-06 更新（二）：**源码已纳入 git 并推送到 GitHub**（`FINEAR/FINEAR.github.io` 仓库的 `source` 分支）——换电脑再也不用拷硬盘。新增两个双击脚本：`blog-demo\publish.cmd`（一键发布）与 `blog-demo\preview.cmd`（本地预览）。本说明书新增第零节（最快路径）、第八节（换电脑）与第九节（报错急救表）。

---

## 零、最快路径（只想发一篇文章时看这里）

**1)** 按 `Win` 键，输入 `powershell`，回车，打开蓝色窗口。

**2)** 逐行粘贴执行（**所有命令都必须在 `F:\Hexo-blog\blog-demo` 目录里跑**）：

```
cd F:\Hexo-blog\blog-demo
npx hexo new "我的新文章标题"
```

这会生成 `source\_posts\我的新文章标题.md`。用 VS Code 或记事本打开它写内容。

**3)** 本地预览（强烈建议，能省掉大量来回）：

```
npx hexo server
```

浏览器打开 <http://localhost:4321/>。改完 Markdown **存盘后刷新浏览器**即可看到效果。看完按 `Ctrl + C` 停止。

**4)** 发布：

```
npx hexo clean ; npx hexo generate ; npx hexo deploy
```

**5)** 等 1~2 分钟，浏览器打开 <https://cxh.net.cn/>，按 **`Ctrl + F5`** 强制刷新。

> **懒人版**：不想敲命令就双击 `F:\Hexo-blog\blog-demo\publish.cmd`（发布）或 `preview.cmd`（预览），效果完全一样。

**三条铁律**：

1. 所有 `npx hexo ...` 命令都必须在 `F:\Hexo-blog\blog-demo` 里执行，否则会报 `not a git repository` 之类；
2. 发之前**必须有 `hexo generate`**——只跑 `deploy` 不会重新生成页面，你改的内容发不上去；
3. 有公式的文章，front-matter 里必须写 `mathjax: true`，否则公式会原样显示成 `\(...\)`。

---

## 一、现状体检结论

| 项目 | 状态 |
| --- | --- |
| 线上网站 https://cxh.net.cn/ | ✅ 正常访问（HTTP 200），7 篇文章（DMFT 入门、洪特耦合与洪特金属、三轨道原子极限） |
| 源码目录 | `F:\Hexo-blog\blog-demo`（Hexo 6.3.0 + Butterfly 4.6.1 主题） |
| 源码 vs 线上 | ✅ 完全同步；`hexo deploy` 后 Vercel 约 30 秒、GitHub Pages 约 1 分钟自动更新 |
| 本地构建 `hexo generate` | ✅ 成功（31 个文件，约 5 秒） |
| 本地预览 `hexo server` | ✅ 成功（http://localhost:4321/） |
| 本地环境 | ✅ Node v18.13.0 / npm 8.19.3 / Pandoc 2.16.2 / node_modules 完整 |
| **GitHub SSH 密钥** | ✅ 2026-10-04 重新添加公钥后验证通过，`hexo deploy` 推送正常 |
| 源码版本管理 | ⚠️ 没有 git 仓库，只有部署产物 `.deploy_git` 有 |
| 公式与表格滚动条 | ✅ 2026-10-04 修复（见第六节第 11 条） |
| 公式加载 CDN | ✅ 已从 jsDelivr 换到国内可达的 elemecdn（见第 12 条） |
| 评论系统 | ⚠️ 已从 Valine 切到 Giscus，还差填一个 `category_id`（见第 9 条） |
| 访客统计 | ❌ 不蒜子（busuanzi）后台已挂，已整体关闭，转圈消失（见第 13 条） |

### 托管链路（重要）

```
本地 Hexo 源码 (F:\Hexo-blog\blog-demo)
        ↓  hexo deploy（git push）
GitHub 仓库  FINEAR/FINEAR.github.io  (main 分支)
        ↓  自动部署
Vercel       →   自定义域名  https://cxh.net.cn/     ← 实际在用的入口
GitHub Pages →   https://finear.github.io/            ← 同一份内容，也在线
```

- 域名 `cxh.net.cn` 的 DNS 指向 `76.76.21.21` / `cname.vercel-dns.com`，**这是 Vercel**，不是 GitHub Pages（DNS 托管在 **DNSPod**：`arrow.dnspod.net` / `leeks.dnspod.net`）。
- 最后发布时间：2026-10-04 14:02（提交 `5fd82e0`，新增 DMFT 入门一篇）；此前是 2023-02-10。

> ### ✅ 已解决：cxh.net.cn（Vercel）的自动部署（2026-10-04 修复）
>
> **结论先行**：Vercel 项目设置里的 Node.js 版本还是 2023 年建项目时留下的 `18.x`。Vercel 停用 18.x 之后，**每次 push 触发的云端构建都直接失败**，网站就一直挂着最后一次成功的旧部署。把项目设置改成 `24.x` 后自动部署完全恢复——实测推送后 **28 秒** cxh.net.cn 就更新了。
>
> 下面是当时的排查记录，留作参考。推送提交 `220581d` 后：
>
> | 入口 | 是否更新 | 证据 |
> | --- | --- | --- |
> | `https://finear.github.io/`（GitHub Pages） | ✅ 1 分钟内更新 | `Last-Modified: 2026-10-04 05:27:37 GMT`，canonical 已变 `https://` |
> | `https://cxh.net.cn/`（Vercel） | ❌ 当时等了 10 分钟没动 | `Last-Modified` 停在 `2026-10-02 23:53:22 GMT`，canonical 仍是 `http://` |
>
> 当时的影响：写的新文章只会出现在 `finear.github.io`，**不会**出现在 `cxh.net.cn`。
>
> **根本原因（2026-10-04 查明）**：Vercel 给用户发的邮件说"项目使用的 Node.js 18.x 已停用，需改用 24.x"。Vercel 是在**它自己的构建服务器**上跑构建的，用的版本由**项目设置**决定，跟本机 Node 版本无关。本项目是 2023 年创建的，当时 Vercel 默认 Node 18.x 被存进了项目设置；Vercel 现在停用 18.x，于是**每次 push 触发的构建都直接失败**，Vercel 就继续挂着上一次成功部署（2026-10-02 那次，内容是 2023 年的旧版）。
>
> 注意：仓库里**没有** `package.json` / `.nvmrc` / `vercel.json`，所以版本只能去 Vercel 网页后台改，改代码没用。
>
> **实际修复步骤（已执行成功，留作以后参考）**：
> 1. 登录 <https://vercel.com/dashboard>，找到这个项目（名字大概含 `finear-github-io`）
> 2. **Settings → General → Node.js Version**（新版界面可能在 **Settings → Build and Deployment**），把 `18.x` 改成 `24.x`，保存
> 3. 下次 `hexo deploy` 推送新提交，Vercel 就会自动用 24.x 重建；也可以到 **Deployments** 里对失败的那条点 `...` → **Redeploy**
> 4. 2026-10-04 14:02:03 推送提交 `5fd82e0`，14:02:31 Vercel 的 `Last-Modified` 即刷新，新文章立即可访问
>
> **以后再收到 Vercel 关于 Node 版本到期的邮件**，照第 1~2 步把版本升到 Vercel 要求的值即可——不用动本机 Node，也不用改任何代码。
>
> 备用修法（改用 GitHub Pages）：GitHub Pages 已验证能自动跟随 push。把 DNSPod 里 `cxh.net.cn` 的 A 记录改成 `185.199.108.153` / `185.199.109.153` / `185.199.110.153` / `185.199.111.153`，`www` 的 CNAME 改成 `finear.github.io`，再在 GitHub 仓库 **Settings → Pages → Custom domain** 填 `cxh.net.cn`。**注意**：走这条路必须在 `source\` 里放一个内容为 `cxh.net.cn` 的 `CNAME` 文件（否则每次 `hexo deploy` 会把 GitHub 自动生成的 CNAME 冲掉，自定义域名会掉）。
>
> **关于本机 Node**：本机 `v18.13.0` 只用于本地 `hexo generate` / `hexo server`，目前完全够用，**不需要为了这个邮件升级**。如果哪天要升级，先确认 Hexo 6.3 在新版本上还能构建（`npx hexo clean; npx hexo generate`）。


---

## 二、日常更新四步走

打开终端（VSCode 的终端或 PowerShell），先进入目录：

```powershell
cd F:\Hexo-blog\blog-demo
```

### 第 1 步：写新文章

```powershell
npx hexo new "我的新文章标题"
```

会在 `source/_posts/` 下生成 `我的新文章标题.md`，用 VSCode 打开编辑。

> 也可以用已有的 npm 脚本：`npm run server` / `npm run clean` / `npm run build` / `npm run deploy`。

### 第 2 步：本地预览（强烈建议）

```powershell
npx hexo server
```

浏览器打开 <http://localhost:4321/> 检查效果。改完 Markdown 存盘后**刷新浏览器即可**，不用重启。
看完按 `Ctrl + C` 停止。

### 第 3 步：生成 + 发布

```powershell
npx hexo clean      # 清理缓存（改过配置或主题后必做）
npx hexo generate   # 生成静态页面到 public/
npx hexo deploy     # 推送到 GitHub
```

或者一条命令搞定：

```powershell
npx hexo clean ; npx hexo generate ; npx hexo deploy
```

### 第 4 步：等 1~2 分钟

Vercel 检测到 GitHub 有新提交后会自动重新部署。刷新 <https://cxh.net.cn/> 即可看到更新。
（可以登录 <https://vercel.com/dashboard> 看部署进度和日志。）

---

## 三、文章怎么写

### 文件头部（Front-matter）格式

每篇 `.md` 开头必须是 `---` 包起来的一段配置。`Post Front-matter.md` 里有完整模板，常用的就这几项：

```markdown
---
title: 文章标题
date: 2026-10-04 15:30:00
updated: 2026-10-04 15:30:00
tags:
  - 标签1
  - 标签2
categories:
  - 分类1
description: 首页摘要，会显示在列表里
cover: /img/封面图.jpg
top_img: /img/顶部图.jpg
mathjax: true     # 文章里有公式时加上
---
```

正文直接写 Markdown：`#` 标题、`**粗体**`、`- 列表`、`[链接](url)`、`` `代码` ``、`> 引用`。

### 数学公式（已开启 MathJax）

- 行内公式：`$E=mc^2$`
- 独立公式：`$$\lim_{x \to \infty} \frac{1}{x} = 0$$`

参考已有的 `test.md`。

### 插图

本博客没有开启 `post_asset_folder`，统一把图片放到 `source/img/` 目录，正文里用根路径引用：

```markdown
![说明文字](/img/我的图.png)
```

### 新建独立页面（如"关于我"）

```powershell
npx hexo new page about
```

会生成 `source/about/index.md`。现有页面：`about`（关于）、`link`（友链）、`tags`、`categories`、`music`、`movies`。

---

## 四、目录结构速查

```
F:\Hexo-blog\blog-demo\
├── source\_posts\        ← 你的文章（Markdown），主要在这里干活
├── source\img\           ← 图片
├── source\about\ 等      ← 独立页面
├── source\_data\link.yml ← 友链数据
├── _config.yml           ← 站点总配置（标题、作者、部署地址）
├── _config.butterfly.yml ← 主题配置（菜单、头像、配色、功能开关）
├── scaffolds\            ← 新建文章的模板
├── public\               ← 生成的静态网站（自动生成，不用手改）
├── .deploy_git\          ← 部署用的 git 仓库（自动生成，不用手改）
└── node_modules\         ← 依赖包（Butterfly 主题在这里）
```

> 注意：`themes\` 目录是空的，主题是通过 npm 装在 `node_modules\hexo-theme-butterfly` 里的——这是 Hexo 支持的正规方式，**不要**手动往 `themes\` 拖主题，否则会和 npm 里的版本冲突。

`_config.fluid.yml`、`_config.landscape.yml` 是当年试主题留下的文件，现在没用到，可以忽略。

---

## 五、GitHub SSH 密钥（2026-10-04 已修好）

**当前状态：正常。** 把本机公钥重新添加到 GitHub 账号 `FINEAR` 后，实测通过：

```
$ ssh -T git@github.com
Hi FINEAR! You've successfully authenticated, but GitHub does not provide shell access.
$ git ls-remote git@github.com:FINEAR/FINEAR.github.io.git main
220581d3df6dafab500eaab0065672f88c552dd3    refs/heads/main
```

> 小陷阱：`ssh -T git@github.com` 认证成功时**退出码也是 1**（因为 GitHub 不给 shell），只要输出里有 `Hi FINEAR! You've successfully authenticated` 就是通了，别被退出码骗到。

### 万一以后又失效（换电脑 / 密钥被删）

症状是 `hexo deploy` 报 `Permission denied (publickey)`，说明 GitHub 账号 `FINEAR` 不再认本机的 `C:\Users\THUNDEROBOT\.ssh\id_rsa`。按下面两种办法之一处理。

### 办法 A：把公钥重新加到 GitHub（推荐，和原来一致）

1. 打开 <https://github.com/settings/keys>（需先登录 `FINEAR` 账号）
2. 点 **New SSH key**，Title 随便填（如 `my-pc-2026`），Key type 选 `Authentication Key`
3. Key 内容粘贴本机公钥，完整内容在文件 `C:\Users\THUNDEROBOT\.ssh\id_rsa.pub` 里
   （整份内容，以 `ssh-rsa AAAA...` 开头，以邮箱结尾）
4. 保存后回到终端验证：

   ```powershell
   ssh -T git@github.com
   ```

   看到 `Hi FINEAR! You've successfully authenticated...` 就成功了。

### 修法 B：改用 HTTPS + 访问令牌

如果 SSH 一直搞不定，可把 `_config.yml` 的 deploy 段改成：

```yaml
deploy:
  type: git
  repository: https://<用户名>:<PersonalAccessToken>@github.com/FINEAR/FINEAR.github.io.git
  branch: main
```

令牌在 <https://github.com/settings/tokens> 生成，勾选 `repo` 权限。
（**注意：令牌相当于密码，别把这段配置发给别人或传到公开仓库。**）

---

## 六、其他小提醒

1. ~~**`url` 写成了 http**~~ ✅ **2026-10-04 已修复**：`_config.yml` 第 16 行已改为 `url: https://cxh.net.cn`。重新构建后页面 `canonical` / `og:url` 全部为 https，生成物里不再出现 `http://cxh.net.cn`。
2. ~~**文章的 `date:` 是空的**~~ ✅ **2026-10-04 已修复**：原本 `test.md`、`妮看看.md` 的 `date:` 为空，`hello-world.md`、`养生论.md` 则完全没有 `date:` 字段——这四篇都在靠文件的创建/修改时间显示日期，哪天顺手编辑一下，"发布日期"就会跳到那天。现已为四篇都补上固定的 `date:` 和 `updated:`（取值就是原先实际显示的时间，所以网站上的日期看起来完全没变）：

   | 文章 | date | updated |
   | --- | --- | --- |
   | hello-world.md | 2023-01-23 22:42:51 | 2023-01-24 11:03:34 |
   | 养生论.md | 2023-01-24 11:26:42 | 2023-01-24 11:34:16 |
   | test.md | 2023-01-24 11:39:06 | 2023-01-24 11:53:06 |
   | 妮看看.md | 2023-01-24 11:47:38 | 2023-01-24 11:53:28 |

   > 以后新建文章建议也照这样把 `date:` 和 `updated:` 都写上，就不会受文件时间影响了。
3. **源码在移动硬盘上、且没有版本管理**：本目录位于外置硬盘 `F:`（文件系统为 **exFAT**），整个博客源码只此一份，硬盘一坏或丢失就全没了。建议：
   - 把 `F:\Hexo-blog\blog-demo` 复制到电脑内置盘或网盘一份；
   - 并给源码建 git 仓库推到 GitHub **私有**仓库（如 `hexo-source`）：

     ```powershell
     cd F:\Hexo-blog\blog-demo
     git init
     git add .
     git commit -m "备份 Hexo 源码"
     ```

   `.gitignore` 已经写好了，`node_modules/`、`public/`、`.deploy_git/` 都不会被提交。
4. **换电脑时**需要装：Node.js（建议 18 LTS）、Git、Pandoc（<https://pandoc.org/installing.html>，`hexo-renderer-pandoc` 依赖它把 Markdown 转 HTML），然后在目录里执行 `npm install`。
5. **exFAT 的小坑**：exFAT 不支持硬链接和符号链接，某些工具（含 DSH 的文件写入）会报 `EISDIR`。如果遇到写入异常，改用 PowerShell 的 `Out-File`/`Copy-Item` 即可。
6. **主题升级**（可选，有风险）：Butterfly 已从 4.6.1 更新很多版，升级前先备份并 `git commit`，因为新版主题配置项有变化。
7. **有公式的文章必须写 `mathjax: true`**：`_config.butterfly.yml` 里 `mathjax.per_page: true`，只有在文章 front-matter 中显式写了 `mathjax: true`，该页才会加载 MathJax。忘了写，公式就会原样显示成 `\(...\)` 记号。可参考示例文章 `source\_posts\DMFT动力学平均场理论入门.md`。
8. **文章链接由文件名决定，不是由 title 决定**：`permalink: :year/:month/:day/:title/` 里的 `:title` 取的是**文件名**（slug）。所以 `hello-world.md` 的标题是 "Hello World"，链接却是 `/2023/01/23/hello-world/`。想要干净好分享的 ASCII 链接，就把文件命名成英文（如 `dmft-intro.md`），标题照旧写中文即可。
9. **评论系统已从 Valine 换成 Giscus**（2026-10-04）：原来是 Valine + LeanCloud，实测报 `Code 504: The app is archived, please restore in console before use`——LeanCloud 把长期未使用的应用归档了。现已改为 **Giscus**（基于 GitHub Discussions，纯前端、免费、无后端）。**还剩最后一步需要你手动做**：
   1. 给仓库开 Discussions：<https://github.com/FINEAR/FINEAR.github.io/settings> → **Features** 区域 → 勾选 **Discussions**
   2. 给仓库装 Giscus App：打开 <https://github.com/apps/giscus> → **Install** → 选择 `FINEAR/FINEAR.github.io`
   3. 打开 <https://giscus.app/zh-CN>，仓库填 `FINEAR/FINEAR.github.io`，Discussion 分类建议选 **Announcements**（只有管理员能发起新讨论，可防灌水）。页面下方会生成一段代码，把其中两个值抄下来：
      - `data-category-id` → 填到 `_config.butterfly.yml` 里 `giscus.category_id`（现在是空的）
      - `data-category`（分类名，例如 `Announcements`）→ 填到 `giscus.option` 下加一行 `data-category: Announcements`
   4. 重新执行 `npx hexo clean; npx hexo generate; npx hexo deploy`，评论就生效了
   （`giscus.repo` 和 `repo_id` 我已经填好了，映射方式固定为 `pathname`，即每篇文章对应一个讨论串。）
10. **第一篇正式文章已发布**：`source\_posts\DMFT动力学平均场理论入门.md`，可作为以后写技术笔记的模板（分类 + 标签 + description + mathjax + 表格 + 数学公式 + 参考文献链接全都用到了）。
11. **公式与表格的横向滚动条已修复**（2026-10-04）：Butterfly 默认给**每一个表格**套了一层 `.table-wrap { overflow-x: scroll }`——注意是 `scroll` 而不是 `auto`，也就是**滚动条常驻**，哪怕表格根本没超宽。这正是"`U/W` 那个表下面总有一条横向滚动条"的来源。此外主题会在 MathJax 渲染完成后，把每个公式包一层 `.mathjax-overflow`（行内公式那层是 `display:inline-block` 且 `overflow-x:auto`），挤在窄容器里（比如表格单元格）时也会冒滚动条。现在的做法是在 `_config.butterfly.yml` 的 `inject.head` 里注入一小段 CSS 覆盖：
    - `.table-wrap { overflow-x: auto }` —— 表格只在真正超宽时才出现滚动条；
    - `span.mathjax-overflow { overflow-x: visible }` —— 行内公式（如 U/W、≪1、∼1）不再产生滚动容器；
    - `div.mathjax-overflow` —— 行显公式保留横向可滚动（超宽长公式仍要能看全），但滚动条改细（6px）、改淡。
    如果连超宽的行显公式也不希望出现滚动条，可以再加规则让公式按比例缩小到刚好放下，代价是公式字体会变小。
12. **MathJax 已换到国内可访问的 CDN**（2026-10-04）：主题默认从 `cdn.jsdelivr.net` 加载 MathJax，国内经常加载失败——一旦失败，页面就把公式原样显示成 `\(...\)` 文本（我实测同一篇文章连续加载两次，一次正常渲染、一次全部退化成原始 LaTeX）。现在在 `CDN.option.mathjax` 里指定了 `https://npm.elemecdn.com/mathjax@3.2.2/es5/tex-mml-chtml.js`，实测 0.9 秒可达（顺带比了 staticfile 和 bootcdn，都要 10 秒以上，太慢）。
    - 注意：页面里还有一批其它脚本（FontAwesome、fancybox、lazyload、pangu 等）仍走 jsDelivr，国内偶尔也会加载慢，表现为图标缺失或特效失效。想彻底解决，可以把 MathJax 连同 web 字体一起下载到 `source/` 里自托管，或在 Vercel 上配一个反向代理。
13. **访客统计（不蒜子）已整体关闭**（2026-10-04）：页面上"本站访客数 / 本站总访问量 / 阅读量"一直转圈，根因是**不蒜子的后台接口挂了**——它的脚本 `busuanzi.pure.mini.js` 本身还能正常下载（HTTP 200），但脚本要去请求的 `https://busuanzi.ibruce.info/busuanzi?jsonpCallback=...` 返回 **502 或直接超时**；JSONP 回调永远不触发，计数器就一直停在 loading 状态。已在 `_config.butterfly.yml` 把 `busuanzi` 的 `site_uv`、`site_pv`、`page_pv` 全部改为 `false`，转圈随之消失。
    - 以后想要访问统计，推荐两条路：**(a) 只看不公开**——用 Vercel Web Analytics（免费）：在 Vercel 后台该项目的 Analytics 标签里开启，再往页面加一行 `<script defer src="/_vercel/insights/script.js"></script>`（可以放到 `_config.butterfly.yml` 的 `inject.head` 里）。数据准确，但只有你登录 Vercel 才看得到，网页上不显示数字。**(b) 要公开展示数字**——得自建一个带存储的计数接口（Cloudflare Worker、Vercel Function + KV、Upstash Redis 等），或者换一个当前确实可用的第三方计数器；纯静态站没有免费的公开计数服务可依赖。
14. **查资料留下的原文副本**：整理《三轨道原子极限与洪特金属的两面神效应》时，我把三篇原始文献的 LaTeX 源码拉到了 `F:\Hexo-blog\literature\`：
    - `arxiv_1106.0815\ArXiv.tex` —— de' Medici, Mravlje, Georges, PRL **107**, 256401 (2011)，即"Janus-faced"那篇；
    - `arxiv_1207.3033\annrev_ag.tex` —— Georges, de' Medici, Mravlje, Annu. Rev. **4**, 137 (2013)，含那张原子极限多重态表；
    - `arxiv_1707.03282\deMedici-Hunds_metals_explained.tex` —— de' Medici 的 Jülich 讲义，含"轨道通道封锁"论证。

    这些只是副本，不影响博客构建（`literature\` 在 `blog-demo\` 之外，不会被部署）。不需要就直接删掉整个 `literature` 目录。

---

## 七、最常用命令备忘

| 目的 | 命令 |
| --- | --- |
| 进目录 | `cd F:\Hexo-blog\blog-demo` |
| 新建文章 | `npx hexo new "标题"` |
| 本地预览 | `npx hexo server`（→ http://localhost:4321/） |
| 清缓存 | `npx hexo clean` |
| 生成静态页 | `npx hexo generate` |
| 发布上线 | `npx hexo deploy` |
| 一键清+生成+发布 | `npx hexo clean ; npx hexo generate ; npx hexo deploy` |
| 验证 GitHub 登录 | `ssh -T git@github.com` |

---

## 八、换一台电脑：从零搭起来

**一句话**：换电脑只需要四件事——装三样软件、配一把新钥匙、把源码 clone 下来装依赖、之后跟在旧电脑上完全一样。

### 8.1 源码在哪里

源码已经在 git 里，并推到了：

```
仓库：git@github.com:FINEAR/FINEAR.github.io.git
分支：source        ← 你的文章和配置都在这里
```

同一个仓库的 `main` 分支是 `hexo deploy` 自动生成的网页产物，**不要手动去改它**。你写的文章只进 `source` 分支。

### 8.2 装三样软件

| 软件 | 干什么用的 | 下载地址 |
| --- | --- | --- |
| Node.js（18 LTS 或 20 LTS） | 跑 Hexo | <https://nodejs.org/> |
| Git for Windows | 拉源码、推文章 | <https://git-scm.com/download/win> |
| **Pandoc** | 把 Markdown 转成 HTML；**缺了它构建直接失败**，最容易漏 | <https://pandoc.org/installing.html> |

装完新开一个 PowerShell 窗口验证：

```
node -v
git --version
pandoc -v
```

三个都能打印版本号就行。

### 8.3 给这台电脑配一把新钥匙

**每台电脑要有自己的 SSH key，不要把旧电脑的私钥拷贝过来。**

```
ssh-keygen -t ed25519 -C "2574542588@qq.com"
```

连按回车（密码可以留空）。然后显示公钥内容：

```
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub
```

把输出的**一整行**（以 `ssh-ed25519` 开头、以邮箱结尾）复制下来，粘到 <https://github.com/settings/keys> → **New SSH key** → Title 随便填 → 保存。

验证：

```
ssh -T git@github.com
```

看到 `Hi FINEAR! You've successfully authenticated` 就通了。

> **注意**：这条命令成功时**退出码也是 1**（因为 GitHub 不提供 shell），别被退出码吓到。

### 8.4 把源码拉下来并装依赖

```
cd D:\                                  # 或你想放的位置
git clone git@github.com:FINEAR/FINEAR.github.io.git hexo-blog
cd hexo-blog\blog-demo
npm install
```

`npm install` 会装 200 多个包，第一次要几分钟，以后不用再装。装完目录里会出现 `node_modules`。

### 8.5 然后就和旧电脑完全一样了

写文章、预览、发布，跟第零节那三条命令一模一样。目录结构也一样（只是根目录从 `F:\Hexo-blog` 变成了 `D:\hexo-blog`）。

### 8.6 收工前多做一步（可选但推荐）

在别的电脑上写完，记得推回远程，否则另一台电脑看不到：

```
cd D:\hexo-blog
git add -A
git commit -m "写了 xxx 这篇"
git push
```

---

## 九、报错急救表

| 报错 / 现象 | 原因 | 怎么办 |
| --- | --- | --- |
| `Permission denied (publickey)` | 这台电脑的钥匙 GitHub 不认 | 回到 8.3 重新配 key |
| `Could not read from remote repository` | 同上，或网络不通 | 先 `ssh -T git@github.com` 确认；通了再 deploy |
| `not a git repository`，或 hexo 命令没反应 | 你不在 `blog-demo` 目录里 | `cd F:\Hexo-blog\blog-demo` |
| `'npx' 不是内部或外部命令` | 没装 Node.js | 装 Node 后重开窗口 |
| `pandoc exited with code null` | 没装 Pandoc | 装 Pandoc，重开窗口 |
| `unsafe repository ... is owned by someone else` | 移动硬盘的属主信息不匹配 | `git config --global --add safe.directory F:/Hexo-blog` |
| `EISDIR`，或写文件失败 | 这块硬盘是 exFAT，不支持硬链接 | 用 VS Code / 记事本另存，或用 `Copy-Item` |
| 网站没更新 | ① 忘了 `hexo generate` ② Vercel 还在部署 ③ 浏览器缓存 | 依次排查，最后按 `Ctrl + F5` |
| 公式显示成 `\(...\)` 原文 | front-matter 少了 `mathjax: true` | 补上，重新发布 |
| 公式一直转圈不出来 | MathJax 的 CDN 没加载上 | 刷新；仍不行见第六节第 12 条 |
| 评论框是空的 | Giscus 还差 `category_id` | 见第六节第 9 条 |

### 怎么确认真的发出去了

1. 执行 `hexo deploy` 时，最后应该打印类似 `abc1234..def5678  HEAD -> main` 的一行——**看到 `-> main` 就是推成功了**；
2. 等 1~2 分钟，浏览器打开 <https://cxh.net.cn/> 并按 `Ctrl + F5`；
3. 想看部署进度：登录 <https://vercel.com/dashboard>，Deployments 列表里最新一条变成 **Ready** 就成了。
