import { Post } from "../hooks/post";

interface FooterProps {
  onSave: () => void;
  onCancel: () => void;
}

export function Footer({ onSave, onCancel }: FooterProps) {
  const handleCancel = async () => {
    try {
      onCancel();
      // Enviar comando para fechar a interface
      await Post.create("closeUI");
    } catch (err) {
      console.error("Erro ao cancelar:", err);
    }
  };

  const handleSave = async () => {
    try {
      onSave();
      // Enviar comando para fechar a interface
      await Post.create("closeUI");
    } catch (err) {
      console.error("Erro ao salvar:", err);
    }
  };

  return (
    <footer className="flex w-full justify-center gap-2 font-semibold">
      <button
        onClick={handleSave}
        className="w-[155px] rounded-md border border-primary bg-gradient-to-b from-primary to-secondary py-2.5 text-sm"
      >
        Salvar
      </button>
      <button
        onClick={handleCancel}
        className="w-[155px] rounded-md border border-white/5 bg-white/5 py-2.5 text-sm duration-300 hover:bg-white/10"
      >
        Cancelar
      </button>
    </footer>
  );
}
