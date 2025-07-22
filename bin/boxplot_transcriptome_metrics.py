#!/usr/bin/env python

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# testar estilos do seaborn 
plt.style.use('seaborn-v0_8-whitegrid')
sns.set_palette("Set2")

busco_df = pd.read_csv('BUSCO.csv')
transrate_df = pd.read_csv('Transrate.csv')
salmon_df = pd.read_csv('Salmon.csv')

# excluir amostra PRJNA794741
busco_df = busco_df[busco_df['BioProject'] != 'PRJNA794741']
transrate_df = transrate_df[transrate_df['BioProject'] != 'PRJNA794741']
salmon_df = salmon_df[salmon_df['BioProject'] != 'PRJNA794741']

# limpar dados do Salmon (remover linhas com Name vazio) - manter apenas valores da coluna Mean
salmon_df = salmon_df.dropna(subset=['Name'])

# converter valores BUSCO para porcentagens
busco_df['Complete_BUSCOs_pct'] = (busco_df['Complete BUSCOs'] / busco_df['Total BUSCO groups searched']) * 100
busco_df['Single_copy_BUSCOs_pct'] = (busco_df['Complete and single-copy BUSCOs'] / busco_df['Total BUSCO groups searched']) * 100
busco_df['Duplicated_BUSCOs_pct'] = (busco_df['Complete and duplicated BUSCOs'] / busco_df['Total BUSCO groups searched']) * 100

# converter GC para porcentagem (multiplicar por 100, pois está em proporção)
transrate_df['gc_pct'] = transrate_df['gc'] * 100

# dados para o boxplot
metrics_data = []

# complete BUSCOs
for idx, row in busco_df.iterrows():
    metrics_data.append({
        'Name': row['Name'],
        'Metric': 'Complete BUSCOs',
        'Value': row['Complete_BUSCOs_pct']
    })

# single-copy BUSCOs
for idx, row in busco_df.iterrows():
    metrics_data.append({
        'Name': row['Name'],
        'Metric': 'Complete Single-copy BUSCOs',
        'Value': row['Single_copy_BUSCOs_pct']
    })

# duplicated BUSCOs
for idx, row in busco_df.iterrows():
    metrics_data.append({
        'Name': row['Name'],
        'Metric': 'Complete Duplicated BUSCOs',
        'Value': row['Duplicated_BUSCOs_pct']
    })

# GC content
for idx, row in transrate_df.iterrows():
    metrics_data.append({
        'Name': row['Name'],
        'Metric': 'GC Content',
        'Value': row['gc_pct']
    })

# mapping rate
for idx, row in salmon_df.iterrows():
    metrics_data.append({
        'Name': row['Name'],
        'Metric': 'Mapping Rate',
        'Value': row['Mean (%)']
    })

plot_df = pd.DataFrame(metrics_data)

# criar figura com tamanho apropriado para publicação
fig, ax = plt.subplots(figsize=(12, 8))

# criar boxplot
box_plot = sns.boxplot(
    data=plot_df, 
    x='Metric', 
    y='Value', 
    ax=ax,
    width=0.6,
    linewidth=2,
    showfliers=False  # não mostrar outliers do boxplot para evitar duplicação (já temos stripplot)
)

# adicionar pontos individuais (strip plot) sobreposto ao boxplot
strip_plot = sns.stripplot(
    data=plot_df,
    x='Metric',
    y='Value',
    ax=ax,
    size=6,
    alpha=0.5,
    jitter=True,
    color='black',
    #edgecolor='white',
    linewidth=0.5
)

ax.set_xlabel('Metrics', fontsize=14, fontweight='bold', labelpad=15)
ax.set_ylabel('Percentage (%)', fontsize=14, fontweight='bold', labelpad=15)
ax.set_title('Transcriptome Assembly Quality Metrics', 
             fontsize=16, fontweight='bold', pad=20)

# ajustar labels do eixo X com rotação para melhor legibilidade
plt.xticks(rotation=45, ha='right', fontsize=12)
plt.yticks(fontsize=12)

# adicionar grid sutil
ax.grid(True, alpha=0.3, linestyle='-', linewidth=0.5)
ax.set_axisbelow(True)

# melhorar a aparência do boxplot
for patch in box_plot.artists:
    patch.set_alpha(0.8)
    patch.set_facecolor(patch.get_facecolor())

# remover spines superiores e direitas para visual mais limpo
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.spines['left'].set_linewidth(1.2)
ax.spines['bottom'].set_linewidth(1.2)

# ajustar layout para evitar corte de labels
plt.tight_layout()

# salvar figura em alta resolução para publicação
plt.savefig('transcriptome_metrics_boxplot.png', 
            dpi=300, 
            bbox_inches='tight', 
            facecolor='white', 
            edgecolor='none')

plt.show()
