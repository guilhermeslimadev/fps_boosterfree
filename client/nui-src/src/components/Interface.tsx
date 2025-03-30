import { ContainerOptions } from "./ContainerOptions";

import { Header } from "./Header";

const Interface = () => {
  return (
    <div className="absolute left-12 flex w-[347px] flex-col gap-5 rounded-lg border border-white/5 bg-background/95 p-5 text-white">
      <Header />
      <ContainerOptions />
    </div>
  );
};

export default Interface;
