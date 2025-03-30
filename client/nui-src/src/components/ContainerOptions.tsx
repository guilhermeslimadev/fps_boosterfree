import { useState, useRef, useEffect } from "react";
import { Post } from "../hooks/post";
import { Footer } from "./Footer";

interface SliderProps {
  label: string;
  value: number;
  onChange: (value: number) => void;
}

function Slider({ label, value, onChange }: SliderProps) {
  const [isDragging, setIsDragging] = useState(false);
  const trackRef = useRef<HTMLDivElement>(null);

  const handleMouseDown = (e: React.MouseEvent) => {
    setIsDragging(true);
    updateValue(e.clientX);
  };

  const handleMouseMove = (e: MouseEvent) => {
    if (isDragging) {
      updateValue(e.clientX);
    }
  };

  const handleMouseUp = () => {
    setIsDragging(false);
  };

  const updateValue = (clientX: number) => {
    if (!trackRef.current) return;

    const track = trackRef.current;
    const rect = track.getBoundingClientRect();
    const x = Math.max(0, Math.min(clientX - rect.left, rect.width));
    const percentage = (x / rect.width) * 100;
    onChange(Math.round(percentage));
  };

  useEffect(() => {
    if (isDragging) {
      window.addEventListener("mousemove", handleMouseMove);
      window.addEventListener("mouseup", handleMouseUp);
    }

    return () => {
      window.removeEventListener("mousemove", handleMouseMove);
      window.removeEventListener("mouseup", handleMouseUp);
    };
  }, [isDragging]);

  return (
    <div className="flex flex-col gap-2">
      <span className="font-medium">{label}</span>
      <div className="flex h-12 items-center justify-center rounded-md border border-white/5 bg-white/5 px-4">
        <div
          ref={trackRef}
          className="relative h-1 w-full cursor-pointer rounded-lg bg-white/10"
          onMouseDown={handleMouseDown}
        >
          {/* Progresso */}
          <div
            className="absolute left-0 top-0 h-full rounded-lg bg-primary/50"
            style={{ width: `${value}%` }}
          />

          {/* Thumb */}
          <div
            className="absolute top-1/2 h-4 w-4 -translate-x-1/2 -translate-y-1/2 cursor-grab rounded-full bg-primary transition-transform hover:scale-110 active:cursor-grabbing"
            style={{ left: `${value}%` }}
          />
        </div>
      </div>
    </div>
  );
}

export function ContainerOptions() {
  // Estado permanente (salvo)
  const [savedConfig, setSavedConfig] = useState({
    shadows: 0,
    textures: 0,
    effects: 0,
    lighting: 0,
    distance: 0,
  });

  // Estado temporário (em edição)
  const [tempConfig, setTempConfig] = useState(savedConfig);

  // Carregar configurações iniciais
  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const data = event.data;

      if (data.action === "setConfig") {
        setSavedConfig(data.data);
        setTempConfig(data.data);
      }
    };

    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  // Função para atualizar configurações temporárias
  const updateTempConfig = (newConfig: typeof tempConfig) => {
    setTempConfig(newConfig);
  };

  // Função para salvar configurações
  const handleSave = async () => {
    try {
      await Post.create("updateConfig", tempConfig);
      setSavedConfig(tempConfig);
    } catch (err) {
      console.error("Erro ao salvar configurações:", err);
    }
  };

  // Função para cancelar alterações
  const handleCancel = () => {
    setTempConfig(savedConfig);
  };

  return (
    <div className="flex flex-col gap-4">
      <div className="flex flex-col gap-4">
        <Slider
          label="Otimizar Sombras"
          value={tempConfig.shadows}
          onChange={(value) =>
            updateTempConfig({ ...tempConfig, shadows: value })
          }
        />
        <Slider
          label="Otimizar Texturas"
          value={tempConfig.textures}
          onChange={(value) =>
            updateTempConfig({ ...tempConfig, textures: value })
          }
        />
        <Slider
          label="Otimizar Efeitos"
          value={tempConfig.effects}
          onChange={(value) =>
            updateTempConfig({ ...tempConfig, effects: value })
          }
        />
        <Slider
          label="Otimizar Iluminação"
          value={tempConfig.lighting}
          onChange={(value) =>
            updateTempConfig({ ...tempConfig, lighting: value })
          }
        />
        <Slider
          label="Otimizar Distância"
          value={tempConfig.distance}
          onChange={(value) =>
            updateTempConfig({ ...tempConfig, distance: value })
          }
        />
      </div>
      <Footer onSave={handleSave} onCancel={handleCancel} />
    </div>
  );
}
