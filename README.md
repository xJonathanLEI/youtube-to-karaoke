# YouTube to Karaoke

A Dockernized tool for easily converting an URL to any YouTube video into a Karaoke video file, by downloading the video and adding an instrument-only audio track.

## Usage

```sh
docker run -it --rm \
    -v /local/folder:/output \
    xjonathanlei/youtube-to-karaoke \
    YOUTUBE_URL \
    /output/output.mp4
```

## License

[MIT](./LICENSE)
