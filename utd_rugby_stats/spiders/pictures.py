from pathlib import Path

import scrapy


class PicturesSpider(scrapy.Spider):
    name = "pictures"
    allowed_domains = ["utdallasrugby.weebly.com"]

    # https://docs.scrapy.org/en/latest/topics/media-pipeline.html
    # Start here:  https://utdallasrugby.weebly.com/match-pix.html
    # Next: https://utdallasrugby.weebly.com/2017-2018.html
    # Next: https://utdallasrugby.weebly.com/dust-off-boots.html
    # Find all of these in that page https://utdallasrugby.weebly.com/uploads/9/1/6/5/9165794/dsc-0299_orig.jpg
    start_urls = ["https://utdallasrugby.weebly.com/match-pix.html"]
