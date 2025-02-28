import * as fs from "node:fs";

const rootDir = "./received";

fs.mkdirSync(rootDir, { recursive: true });

const server = Bun.serve({
  port: 8080,
  development: false,
  fetch: async (req): Promise<Response> => {
    const path = new URL(req.url).pathname;
    if (path === "/redirected" && req.method === "GET") {
      return new Response("<p>Redirected</p>", {
        status: 200,
        headers: { "Content-Type": "text/html" },
      });
    }
    await Bun.write("./request.txt", `${req.method} ${req.url}`);

    if (req.method === "POST") {
      const formDataRaw = await req.formData();
      for (const [key, value] of formDataRaw.entries()) {
        const filepath = `${rootDir}/${key}`;
        if (typeof value === "string") {
          await Bun.write(filepath, value);
          continue;
        }
        await Bun.write(filepath, await value.arrayBuffer());
      }
    }

    const redirectCode = await Bun.file("./redirect-code.txt").text();
    return new Response(undefined, {
      status: Number.parseInt(redirectCode, 10),
      headers: { Location: "/redirected" },
    });
  },
});

await Bun.write("./run/netero/ready.fifo", "");

await Bun.file("./run/netero/exit.fifo").text();

await server.stop();
process.exit(0);
