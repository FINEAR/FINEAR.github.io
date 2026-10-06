---
title: DMFT动力学平均场理论入门
date: 2026-10-04 13:54:41
updated: 2026-10-04 13:54:41
categories:
  - 物理
tags:
  - DMFT
  - 强关联电子
  - Hubbard模型
description: 用一个单杂质问题替代整个晶格——DMFT 的核心近似、自洽循环、杂质求解器，以及它和 DFT 结合后到底能算什么。
mathjax: true
---

> 本站第一篇正式的技术笔记。用一页篇幅把 DMFT 的来龙去脉讲清楚：它为什么被发明、核心近似是什么、自洽循环怎么转、以及它在实际计算里处在什么位置。

## 一、为什么要 DMFT

密度泛函理论（DFT/LDA）把电子之间的相互作用压缩成一个静态的交换关联势，对弱关联体系极为成功。但遇到**强关联**体系就会栽跟头：

- **Mott 绝缘体**：LDA 算出金属，实验却是绝缘体（NiO、MnO 是经典例子）。相互作用把电子"钉"在格点上，LDA 描述不了。
- **准粒子权重与有效质量**：实验测到的有效质量可以是能带值的几十倍，LDA 的能带太"轻"。
- **谱函数的多峰结构**：光电子谱里出现的下 Hubbard 带、上 Hubbard 带、准粒子峰，LDA 完全没有。

根源在于：**关联效应本质上是"动力学"的，即依赖于频率（时间）**；而 LDA 给出的只是一个静态平均场。要描述它，就必须让自能带上频率依赖。

## 二、起点：Hubbard 模型

单轨道 Hubbard 模型是研究强关联时最小、也最核心的模型：

$$H = -t \sum_{\langle ij \rangle \sigma} \left( c^{\dagger}_{i\sigma} c_{j\sigma} + \mathrm{h.c.} \right) + U \sum_i n_{i\uparrow} n_{i\downarrow} - \mu \sum_{i\sigma} n_{i\sigma}$$

- 第一项：电子在近邻格点间的跳跃，给出能带，带宽 $W \sim 2zt$（$z$ 是配位数）
- 第二项：同一格点上两个电子之间的库仑排斥 $U$
- 第三项：化学势，控制填充数

物理全在 $U/W$ 这个比值里：

| $U/W$ | 物理图像 |
| --- | --- |
| $\ll 1$ | 弱关联，能带图像基本成立 |
| $\sim 1$ | 强关联，需要专门方法 |
| 半满 + 大 $U$ | Mott 绝缘体，电荷被锁住但自旋仍自由 |

难点在于：$N$ 个格点、每个格点都有相互作用，严格求解的代价随 $N$ 指数增长。DMFT 给出的答案是——**别去解整个晶格，把它换成一个杂质问题**。

## 三、核心近似：自能只依赖频率

单粒子格林函数与自能的关系是

$$G(\mathbf{k}, i\omega_n) = \frac{1}{i\omega_n + \mu - \varepsilon_{\mathbf{k}} - \Sigma(\mathbf{k}, i\omega_n)}$$

一般情况下 $\Sigma$ 既依赖动量 $\mathbf{k}$ 又依赖频率 $\omega$，这是所有麻烦的来源。

**DMFT 的核心近似**只有一句话：

$$\Sigma(\mathbf{k}, i\omega_n) \approx \Sigma(i\omega_n)$$

即自能**完全局域**：只带频率依赖，不带动量依赖。

这个近似不是随手拍的。在**无穷维极限** $d \to \infty$（等价地 $z \to \infty$，同时把跳跃积分按 $1/\sqrt{z}$ 缩放以保持带宽有限）下，它是**严格成立**的：

- 任何包含非局域传播的自能图都会带上 $1/z$ 或更高阶的因子，在 $z \to \infty$ 时被压掉；
- 存活下来的只有"局域"的图，而它们的拓扑结构恰好与**单杂质 Anderson 模型**的图一一对应。

也就是说，无穷维晶格问题与一个杂质问题是严格等价的。这就是 DMFT 的立足点。

物理图像：把晶格中某个格点单独拎出来，它感受到的其余所有格点的效果，可以等效成一个**介质（bath）**，二者之间的耦合由一个杂化函数 $\Delta(i\omega_n)$ 描述。于是晶格问题被映射成单杂质 Anderson 模型：

$$H_{\mathrm{imp}} = \sum_{\sigma} \varepsilon_d \, n_{d\sigma} + U \, n_{d\uparrow} n_{d\downarrow} + \sum_{\mathbf{k}\sigma} \varepsilon_{\mathbf{k}} c^{\dagger}_{\mathbf{k}\sigma} c_{\mathbf{k}\sigma} + \sum_{\mathbf{k}\sigma} \left( V_{\mathbf{k}} c^{\dagger}_{\mathbf{k}\sigma} d_{\sigma} + \mathrm{h.c.} \right)$$

## 四、自洽循环

DMFT 的算法就是一个**不动点迭代**：给定一个自能猜测，走一圈再回来，直到输入与输出一致。

1. **初始化**：$\Sigma(i\omega_n) = 0$，或取 Hartree–Fock 的结果
2. **算局域格林函数**：对布里渊区求和，把 $\mathbf{k}$ 积掉

   $$G_{\mathrm{loc}}(i\omega_n) = \sum_{\mathbf{k}} \frac{1}{i\omega_n + \mu - \varepsilon_{\mathbf{k}} - \Sigma(i\omega_n)}$$

   实际计算中通常用态密度做 Hilbert 变换，或直接在 $\mathbf{k}$ 网格上求和
3. **反解 bath 函数**：要求"杂质感受到的环境"与"晶格给出的环境"一致

   $$\mathcal{G}_0^{-1}(i\omega_n) = G_{\mathrm{loc}}^{-1}(i\omega_n) + \Sigma(i\omega_n)$$

   $$\Delta(i\omega_n) = i\omega_n + \mu - \varepsilon_d - \mathcal{G}_0^{-1}(i\omega_n)$$

4. **解杂质问题**：把 $\Delta$ 交给杂质求解器，算出新的杂质自能 $\Sigma_{\mathrm{imp}}(i\omega_n)$
5. **判收敛**：比较 $\Sigma_{\mathrm{imp}}$ 与输入的 $\Sigma$。收敛就停；否则做混合（线性混合或 Broyden 方法）后回到第 2 步

整个循环的物理含义可以概括成一句对话：

> 晶格对杂质说："你周围的环境长这样。"（通过 $\Delta$）
>
> 杂质对晶格说："那我这么响应。"（通过 $\Sigma$）

反复对话，直到双方自洽：

$$G_{\mathrm{imp}}(i\omega_n) = G_{\mathrm{loc}}(i\omega_n) \qquad \Longleftrightarrow \qquad \Sigma_{\mathrm{imp}}(i\omega_n) = \Sigma(i\omega_n)$$

"平均场"这个词的来处就在这里——每个格点看到的只是其余格点的**平均**效果。但它与传统静态平均场（Hartree–Fock、Weiss 分子场）的关键区别是：这个"环境"带着**完整的频率依赖**，因此可以描述准粒子、Hubbard 带这些纯粹的动力学效应。所以叫**动力学**平均场。

## 五、杂质求解器

DMFT 的精度和能处理的温区，几乎完全取决于用什么去解杂质模型。

| 求解器 | 思路 | 优势 | 局限 |
| --- | --- | --- | --- |
| ED 精确对角化 | 把连续 bath 离散成有限个格点 | 可到零温、直接得到实频结果 | bath 离散化引入误差，格点数受限 |
| CT-QMC 连续时间量子蒙特卡洛 | 对配分函数做随机级数展开并求和 | 无离散化误差、精度可控 | 有费米子符号问题；得到虚频数据，需解析延拓 |
| NRG 数值重整化群 | 对 bath 做对数离散 + 迭代对角化 | 动力学范围极大，擅长低能物理 | 主要适合单带或少数轨道，多带代价高 |
| NCA / OCA 自洽微扰 | 对杂质自能做图展开求和 | 便宜、直接给实频 | 低温下失效 |

目前多轨道体系里最常用的是 **CT-HYB**（杂化展开），它对包含 Hund 耦合的多轨道问题比较稳健，也是许多 DFT+DMFT 程序（TRIQS、w2dynamics、iQIST、ComDMFT 等）的默认选择。

绕不开的痛点：QMC 给出的是虚频轴上的 $\Sigma(i\omega_n)$ 与 $G(i\omega_n)$，而实验关心的是实频谱函数

$$A(\omega) = -\frac{1}{\pi} \, \mathrm{Im} \, G(\omega)$$

从虚频到实频需要**解析延拓**——最大熵方法（MaxEnt）、随机解析延拓（Stochastic Analytic Continuation）或 Padé 近似。这本质上是一个病态反问题，也是 DMFT 结果不确定度的重要来源。

## 六、与 DFT 结合：DFT+DMFT

LDA 对电荷密度和晶体结构的描述其实相当可靠，真正出错的是关联效应的处理。所以最实用的路线是分工合作：

1. **DFT** 自洽计算，得到 Kohn–Sham 能带和波函数
2. 挑出关联轨道（过渡金属的 $d$、稀土的 $f$），构造**局域轨道（Wannier 函数）**
3. 投影得到低能**有效多轨道 Hubbard 模型**：跳跃参数 $t_{ij}$ 来自 DFT，相互作用 $U$、$J$ 通常用**约束随机相近似（cRPA）**计算，并小心处理与 LDA 的**双重计数**问题
4. 对这个多轨道模型跑 **DMFT**
5. 输出自能、谱函数、准粒子权重等物理量

它能算的东西：

- **谱函数** $A(\mathbf{k}, \omega)$：可以直接与 ARPES 对比，这也是 DFT+DMFT 最有说服力的地方
- **准粒子权重与质量增强**：$Z = \left[ 1 - \frac{\partial \, \mathrm{Im} \Sigma(\omega)}{\partial \omega} \right]^{-1}$，有效质量 $m^*/m = 1/Z$
- **Mott 转变**与**轨道选择性 Mott 转变**：多轨道体系中不同轨道在不同 $U$ 下先后局域化
- **Hund 金属**：由 Hund 耦合而非 Mott 机制驱动的坏金属行为
- 输运性质：电阻率、光学电导、热电效应

## 七、局限与扩展方向

DMFT 的软肋和它的核心近似是同一件事——**忽略了非局域关联**。

- $\Sigma(\mathbf{k}, \omega) \approx \Sigma(\omega)$ 在三维体系通常是不错的近似，但在**低维（尤其二维）**体系偏差明显。铜氧化物高温超导的 $d$ 波关联就要求带 $\mathbf{k}$ 依赖的自能。
- **团簇扩展**是主要的两条路：
  - **CDMFT**（团簇 DMFT）：把若干格点组成团簇整体嵌入介质，恢复短程空间关联
  - **DCA**（动力学团簇近似）：在团簇动量空间上采样，能恢复部分 $\mathbf{k}$ 依赖
- 其他方向：GW+DMFT、DMFT 加 $1/z$ 修正、E-DMFT（处理长程库仑），以及与各种激发态方法的结合。

另外要注意 DMFT 是**有限温**方法：QMC 类求解器要求 $T > 0$，低温下计算代价急剧上升。

## 八、一句话总结

> DMFT 用一个**自洽嵌入的单杂质问题**替代整个晶格：近似掉自能的动量依赖，但完整保留其频率依赖。它把"强关联"从解不动的高维多体问题，变成了能算的杂质问题，代价是牺牲了空间关联。

## 延伸阅读

1. A. Georges, G. Kotliar, W. Krauth, M. J. Rozenberg, *Dynamical mean-field theory of strongly correlated fermion systems and the limit of infinite dimensions*, Rev. Mod. Phys. **68**, 13 (1996). [DOI](https://doi.org/10.1103/RevModPhys.68.13)
2. G. Kotliar, S. Y. Savrasov, K. Haule, V. S. Oudovenko, O. Parcollet, C. A. Marianetti, *Electronic structure calculations with dynamical mean-field theory*, Rev. Mod. Phys. **78**, 865 (2006). [DOI](https://doi.org/10.1103/RevModPhys.78.865)
3. W. Metzner, D. Vollhardt, *Correlated Lattice Fermions in $d = \infty$ Dimensions*, Phys. Rev. Lett. **62**, 324 (1989). [DOI](https://doi.org/10.1103/PhysRevLett.62.324)
4. E. Gull, A. J. Millis, A. I. Lichtenstein, A. N. Rubtsov, M. Troyer, P. Werner, *Continuous-time Monte Carlo methods for quantum impurity models*, Rev. Mod. Phys. **83**, 349 (2011). [DOI](https://doi.org/10.1103/RevModPhys.83.349)
5. K. Held, *Electronic structure calculations using dynamical mean field theory*, Adv. Phys. **56**, 829 (2007). [DOI](https://doi.org/10.1080/00018730701619647)

---

*这是学习笔记性质的中文整理，偏重物理图像与算法结构，省略了图论推导和具体程序的实现细节。若有错误欢迎指出。*
