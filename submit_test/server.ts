import * as fs from "node:fs";

const rootDir = "./received";

fs.mkdirSync(rootDir, { recursive: true });

const server = Bun.serve({
  port: 8080,
  fetch: async (req): Promise<Response> => {
    await Bun.write("./request.txt", `${req.method} ${req.url}`);

    if (req.method !== "POST") {
      return new Response(undefined, { status: 200 });
    }

    const formDataRaw = await req.formData();
    for (const [key, value] of formDataRaw.entries()) {
      const filepath = `${rootDir}/${key}`;
      if (typeof value === "string") {
        await Bun.write(filepath, value);
        continue;
      }
      await Bun.write(filepath, await value.arrayBuffer());
    }
    return new Response(undefined, { status: 200 });
  },
});

await Bun.write("./run/netero/ready.fifo", "");

await Bun.file("./run/netero/exit.fifo").text();

await server.stop();
process.exit(0);
