# Interface FPS Booster

Interface React do FPS Booster, desenvolvida com TypeScript e TailwindCSS.

## 🛠️ Tecnologias

- React
- TypeScript
- TailwindCSS
- Vite

## 📦 Dependências

Certifique-se de ter o Node.js 16+ instalado.

## 🚀 Desenvolvimento

1. Instale as dependências:

```bash
npm install
```

2. Inicie o servidor de desenvolvimento:

```bash
npm run dev
```

3. Para compilar:

```bash
npm run build
```

## 📁 Estrutura

```
src/
├── components/     # Componentes React
│   ├── ContainerOptions.tsx  # Container principal
│   ├── Footer.tsx           # Botões de ação
│   ├── Header.tsx          # Cabeçalho
│   └── Slider.tsx         # Componente do slider
├── hooks/         # Hooks personalizados
│   └── post.ts   # Hook para comunicação NUI
├── styles/       # Estilos TailwindCSS
└── utils/        # Funções utilitárias
```

## 🎨 Personalizando

### Cores

As cores principais podem ser modificadas em `tailwind.config.js`:

```js
theme: {
    extend: {
        colors: {
            primary: '#your-color',
            secondary: '#your-color'
        }
    }
}
```

### Componentes

Cada componente está em um arquivo separado em `src/components/`. Você pode modificá-los conforme necessário.

### Comunicação com o FiveM

A comunicação com o FiveM é feita através do hook `post.ts`. Os eventos disponíveis são:

- `closeUI`: Fecha a interface
- `updateConfig`: Atualiza as configurações

## 📝 Notas

- Mantenha a estrutura de arquivos para garantir compatibilidade
- Após modificações, sempre execute `npm run build`
- A build será gerada na pasta `../nui/`
