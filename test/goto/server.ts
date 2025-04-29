import * as fs from "node:fs";

const rootDir = "./received";

fs.mkdirSync(rootDir, { recursive: true });

const server = Bun.serve({
  port: 8080,
  fetch: async (req): Promise<Response> => {
    await Bun.write("./request.txt", `${req.method} ${req.url}`);

    return new Response("<h1>Received</h1>", {
      status: 200,
      headers: { "Content-Type": "text/html" },
    });
  },
});

await Bun.write("./ready.fifo", "");

await Bun.file("./exit.fifo").text();

await server.stop();
process.exit(0);
