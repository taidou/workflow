---
author: curiousbull
---

TODO 理论准备
=============

TODO 程序化过程
===============

NEXT 9-quark 体系
-----------------

### TODO 程序化

#### 2015 年 8 月重庆重子会议, 实验上对三重子态 `neutron-proton-Lambda` (nn$\Lambda$) 已经有部分证据, 急需理

论支持.

#### DONE Color Part

简单起见, 计算选择 `color singlet` , 生成波函数步骤如下:

1.  三个重子 color 都为 1 2 3
2.  对三个重子做循环, 这样可以设置每个单独重子 `color` 的置换
3.  定义一个正序 (1 2 3) , 之后对每个重子内的每个 `quark` 做循环, 三个
    `quark` 就有三重循环, 要求: 每一重循环的 `quark` 必须不同,
    按顺序依次将每一重循环的 `quark` 的 `color` 标定为 (1 2 3), 这样,
    三个小循环结束, 对应一个重子内的 `quark` 所有颜色的排列均已生成, 为
    $3!$ 项.
4.  在重子循环体内, 三个 `quark` 颜色交换结束, 计算逆序值,
    即只要外层循环 `quark` 的 `color` 值比它内 层 `quark` 的 `color`
    值大, 每比一个 `quark` 大一次, 那么对应的逆序数加 1 .
    用一个数组将对应重子内 所有的 `color` 组合记录下来,
    用一个值将该重子的逆序数记录下来, 该重子 `color` 每一项系数为 -1
    的 逆序数次幂.
5.  整体的 `9-quark` 体系对应 `color` 的每一项系数乘积. 按顺序,
    将三个重子的 `color` 和总体系数写出到 对应文件上. 可以得到
    `color` 的波函数.

<div>

<span class="label">头文件</span>
``` {.cpp}
  #ifndef GEN_WFC_H
  #define GEN_WFC_H

  #include <cmath>

  //define constants
  const int kClusterNum = 3;
  const int kColorNum = 3;
  const int kClusterQrkNum = 3;
  const int kMaxClusterCombColor = 6;
  const int kColorCombNum = 6;
  const int kWaveFuncNum = 1;
  const int kWaveFuncTermNum = 216;

  const int kRegColor[3] = {1, 2, 3};
  const double kRegCof = 1.0/pow(6.0,1.5);
  #endif
```

</div>

<div>

<span class="label">源文件</span>
``` {.cpp}
  #include "gen_wfc.h"
  #include <iostream>
  #include <fstream>
  #include <cmath>
  #include <iomanip>

  using namespace std;

  int main()
  {
    //record color combination within a baryon
      int comb_color_num = 0;
      //record each baryon each color term
      int cluster_color[kClusterNum][kColorCombNum][kClusterQrkNum];
      //record each baryon coefficiency
      double cluster_cof[kClusterNum][kMaxClusterCombColor];
      //loop for baryons
      for(int i = 0; i < kClusterNum; i++)
      {
          comb_color_num = 0;
          int color_idx[kColorNum];
          //three loops for each quark in a baryon
          for(int j = 0; j < kColorNum; j++)
          {
              color_idx[j] = kRegColor[0];
              for(int k = 0; k < kColorNum; k++)
              {
                  if(k == j)
                      continue;
                  color_idx[k] = kRegColor[1];
                  for(int l = 0; l < kColorNum; l++)
                  {
                      if(l == k || l==j)
                          continue;
                      color_idx[l] = kRegColor[2];
                      //calculate coefficiency
                      int neg_pow = 0;
                      for(int iqrk = 0; iqrk < kClusterNum; iqrk++)
                      {
                          cluster_color[i][comb_color_num][iqrk] = color_idx[iqrk];
                          for(int idx_low = 0; idx_low < (kColorNum-1); idx_low++)
                          {
                              for(int idx_up = idx_low+1; idx_up < kColorNum; idx_up++)
                              {
                                  if(color_idx[idx_low] > color_idx[idx_up])
                                  {
                                      neg_pow++;
                                  }
                              }
                          }
                      }
                      cluster_cof[i][comb_color_num] = pow(-1,(double)neg_pow);
                      comb_color_num++;
                  }
              }
          }
      }

      ofstream f;
      f.open("wfc.dat");
      f << kWaveFuncNum << endl;
      f << kWaveFuncTermNum << endl;
      for(int idx1 = 0; idx1 < comb_color_num; idx1++)
      {
          for(int idx2 = 0; idx2 < comb_color_num; idx2++)
          {
              for(int idx3 = 0; idx3 < comb_color_num; idx3++)
              {
                  for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                  {
                      f << cluster_color[0][idx1][iqrk] << " ";
                  }
                  for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                  {
                      f << cluster_color[1][idx2][iqrk] << " ";
                  }
                  for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                  {
                      f << cluster_color[2][idx3][iqrk] << " ";
                  }
                  f << setiosflags(ios::scientific) << setprecision(14) << cluster_cof[0][idx1] * cluster_cof[1][idx2] * cluster_cof[2][idx3] * kRegCof << endl;
              }
          }
      }

      return 0;
  }
```

</div>

#### DONE Flavor and Spin Part

首先需要考虑对称性的问题。由于只计算 `9-quark` 体系基态能量, 因此,
可以认为体系空间部分波函数为对称, 而对于 `color` 部分波函数, 由于只考虑
`color singlet` , 因此该部分不用考虑. 基于以上考虑, 而整个体系
又认为是三重子的组合, 整体波函数必须保证全反对称, 因此, 体系的
`flavor and spin` 部分波函数必须保证 反对称.

具体处理时, 简便起见, 分开生成 `flavor` 和 `spin` 波函数,
最后两者不过是通过 `CG` 系数耦合处理.

##### DONE `flavor` 部分处理

先将两个同位旋均为 1 的重子耦合在一起, 即 `neutron` ($I_3=-1$) 和
`proton` ($I_3=1$). 耦合之后同位旋 有 0, 1 和 2 三种值. 之后将耦合好的
`group` 与 $\Lambda$ 进行耦合, 由于 $\Lambda$ 同位旋为 0 , 因此耦合
后同位旋依然是三种: 0, 1 和 2.

波函数生成过程: 导入三种重子的波函数和每个波函数每一项的值

1.  耦合后总同位旋为 0 对三个重子波函数进行循环,
    前两层波函数认为是同位旋为 1 的重子, 第三层循环为 $\Lambda$
    按照耦合系数 定义整个体系波函数的每一项及其系数,
    归一化检查保证正确后, 将结果输入到文件中保存.
2.  耦合后总同位旋为 1 与上一条目做法相同, 将结果保存到其他文件中保存.
3.  耦合后总同位旋为 2 由于第三分量已经固定为 -1 和 1, 因此此耦合不存在.

具体产生波函数代码如下:

<div>

<span class="label">头文件</span>
``` {.cpp}
  #ifndef GEN_WFF_H
  #define GEN_WFF_H
  const int kClusterNum = 3;
  const int kWaveFuncNum = 2;
  const int kTotalFuncNum = 8;
  const int kClusterQrkNum = 3;
  const int kMaxWaveFuncTermNum = 6;
  const int kTotalMaxWaveFuncTermNum = 108;
  const int kTotalQrkNum = 9;

  int g_tm_wf_num_clt[kClusterNum][kWaveFuncNum];
  double g_tm_wf_norm_clt[kClusterNum][kWaveFuncNum];
  double g_tm_wf_cof_clt[kClusterNum][kWaveFuncNum][kMaxWaveFuncTermNum];
  int g_tm_wf_idx_clt[kClusterNum][kWaveFuncNum][kMaxWaveFuncTermNum][kClusterQrkNum];

  int g_tm_wf_tot[kTotalFuncNum][kTotalMaxWaveFuncTermNum][kTotalQrkNum];
  double g_tm_wf_cof_tot[kTotalFuncNum][kTotalMaxWaveFuncTermNum];
  #endif
```

</div>

<div>

<span class="label">源代码</span>
``` {.cpp}
  #include "gen_wff.h"
  #include <iostream>
  #include <cmath>
  #include <iomanip>
  #include <fstream>

  using namespace std;

  int main()
  {
      ifstream f;
      f.open("flavor.dat");//code order is Neutron Proton and Lambda
      //loop for three baryon
      for(int iby = 0; iby < kClusterNum; iby++)
      {
        //loop for wave function
          for(int iwf = 0; iwf < kWaveFuncNum; iwf++)
          {
              f >> g_tm_wf_num_clt[iby][iwf] >> g_tm_wf_norm_clt[iby][iwf];
              //loop for each term within a wave function
              for(int iwft = 0; iwft < g_tm_wf_num_clt[iby][iwf]; iwft++)
              {
                  for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                  {
                      f >> g_tm_wf_idx_clt[iby][iwf][iwft][iqrk];
                  }
                  f >> g_tm_wf_cof_clt[iby][iwf][iwft];
                  g_tm_wf_cof_clt[iby][iwf][iwft] = g_tm_wf_cof_clt[iby][iwf][iwft]/g_tm_wf_norm_clt[iby][iwf];
              }
          }
      }
      f.close();

      //code wave function and wave function terms
      int idx_wf = 0;
      int idx_wft[kTotalFuncNum];
      //0 0 -> 0
      for(int iwf1 = 0; iwf1 < kWaveFuncNum; iwf1++)
      {
          for(int iwf2 = 0; iwf2 < kWaveFuncNum; iwf2++)
          {
              for(int iwf3 = 0; iwf3 < kWaveFuncNum; iwf3++)
              {
                  idx_wft[idx_wf] = 0;
                  for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[0][iwf1]; iwft1++)
                  {
                      for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[1][iwf2]; iwft2++)
                      {
                          for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[2][iwf3]; iwft3++)
                          {
                              for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                              {
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[0][iwf1][iwft1][iqrk];
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[1][iwf2][iwft2][iqrk];
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[2][iwf3][iwft3][iqrk];
                              }
                              //be careful of the CG coefficiency
                              g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                                + g_tm_wf_cof_clt[0][iwf1][iwft1]
                                ,* g_tm_wf_cof_clt[1][iwf2][iwft2]
                                ,* g_tm_wf_cof_clt[2][iwf3][iwft3]
                                / (-sqrt(2.0));
                              idx_wft[idx_wf]++;
                          }
                      }
                  }
                  for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[1][iwf1]; iwft1++)
                    {
                      for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[0][iwf2]; iwft2++)
                        {
                          for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[2][iwf3]; iwft3++)
                            {
                              for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                                {
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[1][iwf1][iwft1][iqrk];
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[0][iwf2][iwft2][iqrk];
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[2][iwf3][iwft3][iqrk];
                                }
                              g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                                + g_tm_wf_cof_clt[1][iwf1][iwft1]
                                ,* g_tm_wf_cof_clt[0][iwf2][iwft2]
                                ,* g_tm_wf_cof_clt[2][iwf3][iwft3]
                                / (sqrt(2.0));
                              idx_wft[idx_wf]++;
                            }
                        }
                    }
                  idx_wf++;
              }
          }
      }

      ofstream fout;
      fout.open("wff000.dat");
      fout << idx_wf << endl;
      for(int iwf = 0; iwf < idx_wf; iwf++)
      {
        fout << idx_wft[iwf] << endl;
          for(int iwft = 0; iwft < idx_wft[iwf]; iwft++)
          {
              for(int iqrk = 0; iqrk < kTotalQrkNum; iqrk++)
              {
                  fout << g_tm_wf_tot[iwf][iwft][iqrk] << "\t";
              }
              fout << setiosflags(ios::scientific) << setprecision(14) << g_tm_wf_cof_tot[iwf][iwft] << endl;
          }
      }
      fout.close();

      //check normalization
      for(int iwf_left = 0; iwf_left < idx_wf; iwf_left++)
      {
          for(int iwf_right = 0; iwf_right < idx_wf; iwf_right++)
          {
              double cnorm = 0.;
              for(int iwft_left = 0; iwft_left < idx_wft[iwf_left]; iwft_left++)
              {
                  for(int iwft_right = 0; iwft_right < idx_wft[iwf_right]; iwft_right++)
                  {
                      int nsame = 0;
                      for(int iqrk = 0; iqrk < kTotalQrkNum; iqrk++)
                      {
                          if(g_tm_wf_tot[iwf_left][iwft_left][iqrk] == g_tm_wf_tot[iwf_right][iwft_right][iqrk])
                              nsame++;
                          if(nsame == kTotalQrkNum)
                          {
                              cnorm = cnorm + g_tm_wf_cof_tot[iwf_left][iwft_left]*g_tm_wf_cof_tot[iwf_right][iwft_right];
                          }
                      }
                  }
              }
              if(iwf_left == iwf_right)
              {
                  if((cnorm - 1.0) > 0.1)
                  {
                      cout << "error1 happens: " << iwf_left << "\t" << cnorm << endl;
                      return -1;
                  }
              }else{
                  if(cnorm > 0.1)
                  {
                      cout << "error2 happens: " << iwf_left << "\t" << iwf_right << "\t" << cnorm << endl;
                      return -2;
                  }
              }
          }
      }

      //1 0 -> 1
      idx_wf = 0;
      for(int iwf1 = 0; iwf1 < kWaveFuncNum; iwf1++)
        {
          for(int iwf2 = 0; iwf2 < kWaveFuncNum; iwf2++)
            {
              for(int iwf3 = 0; iwf3 < kWaveFuncNum; iwf3++)
                {
                  idx_wft[idx_wf] = 0;
                  for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[0][iwf1]; iwft1++)
                    {
                      for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[1][iwf2]; iwft2++)
                        {
                          for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[2][iwf3]; iwft3++)
                            {
                              for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                                {
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[0][iwf1][iwft1][iqrk];
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[1][iwf2][iwft2][iqrk];
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[2][iwf3][iwft3][iqrk];
                                }
                              g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = -g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                                + g_tm_wf_cof_clt[0][iwf1][iwft1]
                                ,* g_tm_wf_cof_clt[1][iwf2][iwft2]
                                ,* g_tm_wf_cof_clt[2][iwf3][iwft3]
                                / (sqrt(2.0));
                              idx_wft[idx_wf]++;
                            }
                        }
                    }
                  for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[1][iwf1]; iwft1++)
                    {
                      for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[0][iwf2]; iwft2++)
                        {
                          for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[2][iwf3]; iwft3++)
                            {
                              for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                                {
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[1][iwf1][iwft1][iqrk];
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[0][iwf2][iwft2][iqrk];
                                  g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[2][iwf3][iwft3][iqrk];
                                }
                              g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = -g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                                + g_tm_wf_cof_clt[1][iwf1][iwft1]
                                ,* g_tm_wf_cof_clt[0][iwf2][iwft2]
                                ,* g_tm_wf_cof_clt[2][iwf3][iwft3]
                                / (sqrt(2.0));
                              idx_wft[idx_wf]++;
                            }
                        }
                    }
                  idx_wf++;
                }
            }
        }

      fout.open("wff202.dat");
      fout << idx_wf << endl;
      for(int iwf = 0; iwf < idx_wf; iwf++)
        {
          fout << idx_wft[iwf] << endl;
          for(int iwft = 0; iwft < idx_wft[iwf]; iwft++)
            {
              for(int iqrk = 0; iqrk < kTotalQrkNum; iqrk++)
                {
                  fout << g_tm_wf_tot[iwf][iwft][iqrk] << "\t";
                }
              fout << setiosflags(ios::scientific) << setprecision(14) << g_tm_wf_cof_tot[iwf][iwft] << endl;
            }
        }
      fout.close();

      //check normalization
      for(int iwf_left = 0; iwf_left < idx_wf; iwf_left++)
        {
          for(int iwf_right = 0; iwf_right < idx_wf; iwf_right++)
            {
              double cnorm = 0.;
              for(int iwft_left = 0; iwft_left < idx_wft[iwf_left]; iwft_left++)
                {
                  for(int iwft_right = 0; iwft_right < idx_wft[iwf_right]; iwft_right++)
                    {
                      int nsame = 0;
                      for(int iqrk = 0; iqrk < kTotalQrkNum; iqrk++)
                        {
                          if(g_tm_wf_tot[iwf_left][iwft_left][iqrk] == g_tm_wf_tot[iwf_right][iwft_right][iqrk])
                            nsame++;
                          if(nsame == kTotalQrkNum)
                            {
                              cnorm = cnorm + g_tm_wf_cof_tot[iwf_left][iwft_left]*g_tm_wf_cof_tot[iwf_right][iwft_right];
                            }
                        }
                    }
                }
              if(iwf_left == iwf_right)
                {
                  if((cnorm - 1.0) > 0.1)
                    {
                      cout << "error1 happens: " << iwf_left << "\t" << cnorm << endl;
                      return -1;
                    }
                }else{
                if(cnorm > 0.1)
                  {
                    cout << "error2 happens: " << iwf_left << "\t" << iwf_right << "\t" << cnorm << endl;
                    return -2;
                  }
              }
            }
        }
  }
```

</div>

##### DONE `spin` 部分处理

`spin` 部分的波函数处理和 `flavor` 处理类似. 但是由于 `flavor`
部分处理时先将 `neutron` 和 `proton` 耦合在一起处理, 考虑整个 `group` (
`neutron` 和 `proton` 组合 ) 的对称性 (两个费米子交换反对称). 对 体系的
`spin` 处理需要满足对称性要求, 具体如下:

1.  总同位旋为 0 该情况下, `neutron` 和 `proton` 的 `flavor`
    部分波函数反对称, 那么要求两个重子 `spin` 必须全对称, 才可以满足
    `group` 反对称的要求. 因此, `group` 自旋总分量为 1. 之后与
    `$\Lambda` 耦合时, 自旋状态 则一共有两种, 总自旋为 1/2 和
    3/2 两种情况.
    自旋的第三分量对于体系总能量在不考虑磁场影响的情况下 是没有影响的.
    简便起见, 取这两种情况下第三分量均为 1/2.
2.  总同位旋为 1 此时, 由于 `group` 总自旋为 0, 因此体系总自旋为 1/2.
    简单起见, 第三分量一样取成 1/2.

具体代码如下:

<div>

<span class="label">头文件</span>
``` {.cpp}
  #ifndef GEN_WFS_H
  #define GEN_WFS_H
  const int kSpinNum = 2;
  const int kWaveFuncNum = 2;
  const int kTotalFuncNum = 8;
  const int kClusterQrkNum = 3;
  const int kMaxWaveFuncTermNum = 3;
  const int kTotalMaxWaveFuncTermNum = 81;
  const int kTotalQrkNum = 9;

  int g_tm_wf_num_clt[kSpinNum][kWaveFuncNum];
  double g_tm_wf_norm_clt[kSpinNum][kWaveFuncNum];
  double g_tm_wf_cof_clt[kSpinNum][kWaveFuncNum][kMaxWaveFuncTermNum];
  int g_tm_wf_idx_clt[kSpinNum][kWaveFuncNum][kMaxWaveFuncTermNum][kClusterQrkNum];

  int g_tm_wf_tot[kTotalFuncNum][kTotalMaxWaveFuncTermNum][kTotalQrkNum];
  double g_tm_wf_cof_tot[kTotalFuncNum][kTotalMaxWaveFuncTermNum];
  #endif
```

</div>

<div>

<span class="label">源代码</span>
``` {.cpp}
  #include "gen_wfs.h"
  #include <iostream>
  #include <fstream>
  #include <iomanip>
  #include <cmath>

  using namespace std;

  int main()
  {
    ifstream f;
    f.open("spin.dat");//code order is up and down
    for(int ispin = 0; ispin < kSpinNum; ispin++)
      {
        for(int iwf = 0; iwf < kWaveFuncNum; iwf++)
          {
            f >> g_tm_wf_num_clt[ispin][iwf] >> g_tm_wf_norm_clt[ispin][iwf];
            for(int iwft = 0; iwft < g_tm_wf_num_clt[ispin][iwf]; iwft++)
              {
                for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                  {
                    f >> g_tm_wf_idx_clt[ispin][iwf][iwft][iqrk];
                  }
                f >> g_tm_wf_cof_clt[ispin][iwf][iwft];
                g_tm_wf_cof_clt[ispin][iwf][iwft] = g_tm_wf_cof_clt[ispin][iwf][iwft]/g_tm_wf_norm_clt[ispin][iwf];
              }
          }
      }
    f.close();

    //code wave function and wave function terms
    int idx_wf = 0;
    int idx_wft[kTotalFuncNum];
    //0 1/2 -> 1/2
    for(int iwf1 = 0; iwf1 < kWaveFuncNum; iwf1++)
      {
        for(int iwf2 = 0; iwf2 < kWaveFuncNum; iwf2++)
          {
            for(int iwf3 = 0; iwf3 < kWaveFuncNum; iwf3++)
              {
                idx_wft[idx_wf] = 0;
                //alpha beta alpha
                for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[0][iwf1]; iwft1++)
                  {
                    for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[1][iwf2]; iwft2++)
                      {
                        for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[0][iwf3]; iwft3++)
                          {
                            for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                              {
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[0][iwf1][iwft1][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[1][iwf2][iwft2][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[0][iwf3][iwft3][iqrk];
                              }
                            g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                              + g_tm_wf_cof_clt[0][iwf1][iwft1]
                              ,* g_tm_wf_cof_clt[1][iwf2][iwft2]
                              ,* g_tm_wf_cof_clt[0][iwf3][iwft3]
                              / (sqrt(2.0));
                            idx_wft[idx_wf]++;
                          }
                      }
                  }
                //beta alpha alpha
                for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[1][iwf1]; iwft1++)
                  {
                    for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[0][iwf2]; iwft2++)
                      {
                        for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[0][iwf3]; iwft3++)
                          {
                            for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                              {
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[1][iwf1][iwft1][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[0][iwf2][iwft2][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[0][iwf3][iwft3][iqrk];
                              }
                            g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                              + g_tm_wf_cof_clt[1][iwf1][iwft1]
                              ,* g_tm_wf_cof_clt[0][iwf2][iwft2]
                              ,* g_tm_wf_cof_clt[0][iwf3][iwft3]
                              / (-sqrt(2.0));
                            idx_wft[idx_wf]++;
                          }
                      }
                  }
                idx_wf++;
              }
          }
      }

    //output of each ordered terms
    ofstream fout;
    fout.open("wfs0111.dat");
    fout << idx_wf << endl;
    for(int iwf = 0; iwf < idx_wf; iwf++)
      {
        fout << idx_wft[iwf] << endl;
        for(int iwft = 0; iwft < idx_wft[iwf]; iwft++)
          {
            for(int iqrk = 0; iqrk < kTotalQrkNum; iqrk++)
              {
                fout << g_tm_wf_tot[iwf][iwft][iqrk] << "\t";
              }
            fout << setiosflags(ios::scientific) << setprecision(14) << g_tm_wf_cof_tot[iwf][iwft] << endl;
          }
      }
    fout.close();

    //check normalization
    for(int iwf_left = 0; iwf_left < idx_wf; iwf_left++)
      {
        for(int iwf_right = 0; iwf_right < idx_wf; iwf_right++)
          {
            double cnorm = 0.;
            for(int iwft_left = 0; iwft_left < idx_wft[iwf_left]; iwft_left++)
              {
                for(int iwft_right = 0; iwft_right < idx_wft[iwf_right]; iwft_right++)
                  {
                    int nsame = 0;
                    for(int iqrk = 0; iqrk < kTotalQrkNum; iqrk++)
                      {
                        if(g_tm_wf_tot[iwf_left][iwft_left][iqrk] == g_tm_wf_tot[iwf_right][iwft_right][iqrk])
                          nsame++;
                        if(nsame == kTotalQrkNum)
                          {
                            cnorm = cnorm + g_tm_wf_cof_tot[iwf_left][iwft_left]*g_tm_wf_cof_tot[iwf_right][iwft_right];
                          }
                      }
                  }
              }
            if(iwf_left == iwf_right)
              {
                if((cnorm - 1.0) > 0.1)
                  {
                    cout << "error1 happens: " << iwf_left << "\t" << cnorm << endl;
                    return -1;
                  }
              }else{
              if(cnorm > 0.1)
                {
                  cout << "error2 happens: " << iwf_left << "\t" << iwf_right << "\t" << cnorm << endl;
                  return -2;
                }
            }
          }
      }

    //1 1/2 -> 1/2
    idx_wf = 0;
    for(int iwf1 = 0; iwf1 < kWaveFuncNum; iwf1++)
      {
        for(int iwf2 = 0; iwf2 < kWaveFuncNum; iwf2++)
          {
            for(int iwf3 = 0; iwf3 < kWaveFuncNum; iwf3++)
              {
                idx_wft[idx_wf] = 0;
                //alpha beta alpha
                for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[0][iwf1]; iwft1++)
                  {
                    for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[1][iwf2]; iwft2++)
                      {
                        for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[0][iwf3]; iwft3++)
                          {
                            for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                              {
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[0][iwf1][iwft1][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[1][iwf2][iwft2][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[0][iwf3][iwft3][iqrk];
                              }
                            g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                              + g_tm_wf_cof_clt[0][iwf1][iwft1]
                              ,* g_tm_wf_cof_clt[1][iwf2][iwft2]
                              ,* g_tm_wf_cof_clt[0][iwf3][iwft3]
                              / sqrt(2.0)
                              ,* sqrt(-1.0/3.0);
                            idx_wft[idx_wf]++;
                          }
                      }
                  }
                //beta alpha alpha
                for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[1][iwf1]; iwft1++)
                  {
                    for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[0][iwf2]; iwft2++)
                      {
                        for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[0][iwf3]; iwft3++)
                          {
                            for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                              {
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[1][iwf1][iwft1][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[0][iwf2][iwft2][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[0][iwf3][iwft3][iqrk];
                              }
                            g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                              + g_tm_wf_cof_clt[1][iwf1][iwft1]
                              ,* g_tm_wf_cof_clt[0][iwf2][iwft2]
                              ,* g_tm_wf_cof_clt[0][iwf3][iwft3]
                              / sqrt(2.0)
                              ,* sqrt(-1.0/3.0);
                            idx_wft[idx_wf]++;
                          }
                      }
                  }
                //alpha alpha beta
                for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[0][iwf1]; iwft1++)
                  {
                    for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[0][iwf2]; iwft2++)
                      {
                        for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[1][iwf3]; iwft3++)
                          {
                            for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                              {
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[0][iwf1][iwft1][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[0][iwf2][iwft2][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[1][iwf3][iwft3][iqrk];
                              }
                            g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                              + g_tm_wf_cof_clt[1][iwf1][iwft1]
                              ,* g_tm_wf_cof_clt[0][iwf2][iwft2]
                              ,* g_tm_wf_cof_clt[0][iwf3][iwft3]
                              ,* sqrt(2.0/3.0);
                            idx_wft[idx_wf]++;
                          }
                      }
                  }
                idx_wf++;
              }
          }
      }

    //output of each ordered terms
    fout;
    fout.open("wfs2111.dat");
    fout << idx_wf << endl;
    for(int iwf = 0; iwf < idx_wf; iwf++)
      {
        fout << idx_wft[iwf] << endl;
        for(int iwft = 0; iwft < idx_wft[iwf]; iwft++)
          {
            for(int iqrk = 0; iqrk < kTotalQrkNum; iqrk++)
              {
                fout << g_tm_wf_tot[iwf][iwft][iqrk] << "\t";
              }
            fout << setiosflags(ios::scientific) << setprecision(14) << g_tm_wf_cof_tot[iwf][iwft] << endl;
          }
      }
    fout.close();

    //check normalization
    for(int iwf_left = 0; iwf_left < idx_wf; iwf_left++)
      {
        for(int iwf_right = 0; iwf_right < idx_wf; iwf_right++)
          {
            double cnorm = 0.;
            for(int iwft_left = 0; iwft_left < idx_wft[iwf_left]; iwft_left++)
              {
                for(int iwft_right = 0; iwft_right < idx_wft[iwf_right]; iwft_right++)
                  {
                    int nsame = 0;
                    for(int iqrk = 0; iqrk < kTotalQrkNum; iqrk++)
                      {
                        if(g_tm_wf_tot[iwf_left][iwft_left][iqrk] == g_tm_wf_tot[iwf_right][iwft_right][iqrk])
                          nsame++;
                        if(nsame == kTotalQrkNum)
                          {
                            cnorm = cnorm + g_tm_wf_cof_tot[iwf_left][iwft_left]*g_tm_wf_cof_tot[iwf_right][iwft_right];
                          }
                      }
                  }
              }
            if(iwf_left == iwf_right)
              {
                if((cnorm - 1.0) > 0.1)
                  {
                    cout << "error1 happens: " << iwf_left << "\t" << cnorm << endl;
                    return -1;
                  }
              }else{
              if(cnorm > 0.1)
                {
                  cout << "error2 happens: " << iwf_left << "\t" << iwf_right << "\t" << cnorm << endl;
                  return -2;
                }
            }
          }
      }

    //1 1/2 -> 3/2(z=1/2)
    idx_wf = 0;
    for(int iwf1 = 0; iwf1 < kWaveFuncNum; iwf1++)
      {
        for(int iwf2 = 0; iwf2 < kWaveFuncNum; iwf2++)
          {
            for(int iwf3 = 0; iwf3 < kWaveFuncNum; iwf3++)
              {
                idx_wft[idx_wf] = 0;
                //alpha beta alpha
                for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[0][iwf1]; iwft1++)
                  {
                    for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[1][iwf2]; iwft2++)
                      {
                        for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[0][iwf3]; iwft3++)
                          {
                            for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                              {
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[0][iwf1][iwft1][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[1][iwf2][iwft2][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[0][iwf3][iwft3][iqrk];
                              }
                            g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                              + g_tm_wf_cof_clt[0][iwf1][iwft1]
                              ,* g_tm_wf_cof_clt[1][iwf2][iwft2]
                              ,* g_tm_wf_cof_clt[0][iwf3][iwft3]
                              / (sqrt(2.0))
                              ,* (sqrt(2.0/3.0));
                            idx_wft[idx_wf]++;
                          }
                      }
                  }
                //beta alpha alpha
                for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[1][iwf1]; iwft1++)
                  {
                    for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[0][iwf2]; iwft2++)
                      {
                        for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[0][iwf3]; iwft3++)
                          {
                            for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                              {
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[1][iwf1][iwft1][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[0][iwf2][iwft2][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[0][iwf3][iwft3][iqrk];
                              }
                            g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                              + g_tm_wf_cof_clt[1][iwf1][iwft1]
                              ,* g_tm_wf_cof_clt[0][iwf2][iwft2]
                              ,* g_tm_wf_cof_clt[0][iwf3][iwft3]
                              / sqrt(2.0)
                              ,* sqrt(2.0/3.0);
                            idx_wft[idx_wf]++;
                          }
                      }
                  }
                //alpha alpha beta
                for(int iwft1 = 0; iwft1 < g_tm_wf_num_clt[0][iwf1]; iwft1++)
                  {
                    for(int iwft2 = 0; iwft2 < g_tm_wf_num_clt[0][iwf2]; iwft2++)
                      {
                        for(int iwft3 = 0; iwft3 < g_tm_wf_num_clt[1][iwf3]; iwft3++)
                          {
                            for(int iqrk = 0; iqrk < kClusterQrkNum; iqrk++)
                              {
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk] = g_tm_wf_idx_clt[0][iwf1][iwft1][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+3] = g_tm_wf_idx_clt[0][iwf2][iwft2][iqrk];
                                g_tm_wf_tot[idx_wf][idx_wft[idx_wf]][iqrk+6] = g_tm_wf_idx_clt[1][iwf3][iwft3][iqrk];
                              }
                            g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]] = g_tm_wf_cof_tot[idx_wf][idx_wft[idx_wf]]
                              + g_tm_wf_cof_clt[1][iwf1][iwft1]
                              ,* g_tm_wf_cof_clt[0][iwf2][iwft2]
                              ,* g_tm_wf_cof_clt[0][iwf3][iwft3]
                              / sqrt(3.0);
                            idx_wft[idx_wf]++;
                          }
                      }
                  }
                idx_wf++;
              }
          }
      }

    //output of each ordered terms
    fout;
    fout.open("wfs2131.dat");
    fout << idx_wf << endl;
    for(int iwf = 0; iwf < idx_wf; iwf++)
      {
        fout << idx_wft[iwf] << endl;
        for(int iwft = 0; iwft < idx_wft[iwf]; iwft++)
          {
            for(int iqrk = 0; iqrk < kTotalQrkNum; iqrk++)
              {
                fout << g_tm_wf_tot[iwf][iwft][iqrk] << "\t";
              }
            fout << setiosflags(ios::scientific) << setprecision(14) << g_tm_wf_cof_tot[iwf][iwft] << endl;
          }
      }
    fout.close();

    //check normalization
    for(int iwf_left = 0; iwf_left < idx_wf; iwf_left++)
      {
        for(int iwf_right = 0; iwf_right < idx_wf; iwf_right++)
          {
            double cnorm = 0.;
            for(int iwft_left = 0; iwft_left < idx_wft[iwf_left]; iwft_left++)
              {
                for(int iwft_right = 0; iwft_right < idx_wft[iwf_right]; iwft_right++)
                  {
                    int nsame = 0;
                    for(int iqrk = 0; iqrk < kTotalQrkNum; iqrk++)
                      {
                        if(g_tm_wf_tot[iwf_left][iwft_left][iqrk] == g_tm_wf_tot[iwf_right][iwft_right][iqrk])
                          nsame++;
                        if(nsame == kTotalQrkNum)
                          {
                            cnorm = cnorm + g_tm_wf_cof_tot[iwf_left][iwft_left]*g_tm_wf_cof_tot[iwf_right][iwft_right];
                          }
                      }
                  }
              }
            if(iwf_left == iwf_right)
              {
                if((cnorm - 1.0) > 0.1)
                  {
                    cout << "error1 happens: " << iwf_left << "\t" << cnorm << endl;
                    return -1;
                  }
              }else{
              if(cnorm > 0.1)
                {
                  cout << "error2 happens: " << iwf_left << "\t" << iwf_right << "\t" << cnorm << endl;
                  return -2;
                }
            }
          }
      }
  }
```

</div>

#### TODO Orbital Part

#### TODO Total
