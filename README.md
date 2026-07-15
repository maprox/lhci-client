# maprox/lhci-client

Drop-in analog of [`patrickhulce/lhci-client`](https://hub.docker.com/r/patrickhulce/lhci-client) with:

- **Node 24 LTS** (Lighthouse 13 requires Node ≥ 22.19)
- `@lhci/cli@0.15.1`
- forced **`lighthouse@13.4.0`** via npm `overrides`

Official LHCI still pins Lighthouse 12.6.1; this uses the same override approach as
[kianandersson@922edbd](https://github.com/kianandersson/kianandersson/commit/922edbdaee95942d6bd722cd0271599450b8db5c).

## Build & push

```bash
docker build -t maprox/lhci-client:0.15.1-lh13.4.0 -t maprox/lhci-client:latest .
docker push maprox/lhci-client:0.15.1-lh13.4.0
docker push maprox/lhci-client:latest
```

Used as the base image for [`maprox/lhci-autorun`](https://github.com/maprox/lhci-autorun).

## License

MIT — see [LICENSE](LICENSE).
