package com.winning.bisj.utils;/**
 * @Author: huchengwei * @Date: 2021/4/27 14:01 * @Description: *
 */
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.GZIPInputStream;

/**
 * @author     ：huchengwei
 * @date       ：Created in 2021/4/27 14:01
 * @description：
 * @modified By：
 * @version: $
 */
public class AllBalls {
    private static StringBuffer mStringBuffer;

    public static void main(String[] args) {
        System.out.println("正在获取...");
        mStringBuffer = new StringBuffer();

        String baseUrlPrefix = "http://kaijiang.zhcw.com/zhcw/html/ssq/list_";
        String baseUrlSuffix = ".html";
        String homeUrl = "http://kaijiang.zhcw.com/zhcw/html/ssq/list_1.html";
        String pageCountContent = getHtmlString(homeUrl);
//        System.out.println("pageCountContent：" + pageCountContent);
        int pageCount = getPageCount(pageCountContent);
        System.out.println("pageCount：" + pageCount);
        if (pageCount > 0) {
            for (int i = 1; i <= pageCount; i++) {
                String url = baseUrlPrefix + i + baseUrlSuffix;
                String pageContent = getHtmlString(url);
                if (pageContent != null && !pageContent.equals("")) {
                    getOneTermContent(pageContent);
                } else {
                    System.out.println("第" + i + "页丢失");
                }
                try {
                    Thread.sleep(10);
                } catch (Exception e) {
                    // TODO: handle exception
                }
            }

            File file = new File("双色球.txt");
            if (file.exists()) {
                file.delete();
            }

            try {
                FileWriter writer = new FileWriter(file);
                BufferedWriter bufferedWriter = new BufferedWriter(writer);
                bufferedWriter.write(mStringBuffer.toString());
                bufferedWriter.close();
                writer.close();

            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            // BufferedWriter writer = new BufferedWriter(new OutputS)

        } else {
            System.out.println("结果页数为0");
        }

        System.out.println("完成！");
    }

    /**
     * 获取总页数
     *
     * @param result
     */
    private static int getPageCount(String result) {
        String regex = "\\d+\">末页";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(result);
        String[] splits = null;
        while (matcher.find()) {
            String content = matcher.group();
            splits = content.split("\"");
            break;
        }
        if (splits != null && splits.length == 2) {
            String countString = splits[0];
            if (countString != null && !countString.equals("")) {
                return Integer.parseInt(countString);
            }

        }
        return 0;
    }

    /**
     * 获取网页源码
     *
     * @return
     */
    private static String getHtmlString(String targetUrl) {
        String content = null;

        HttpURLConnection connection = null;
        try {
            URL url = new URL(targetUrl);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");

            connection.setRequestProperty("User-Agent",
                    "Mozilla/4.0 (compatible; MSIE 7.0; Windows 7)");
            connection
                    .setRequestProperty(
                            "Accept",
                            "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-powerpoint, application/vnd.ms-excel, application/msword, */*");
            connection.setRequestProperty("Accept-Language", "zh-cn");
            connection.setRequestProperty("UA-CPU", "x86");
            // 为什么没有deflate呢
            connection.setRequestProperty("Accept-Encoding", "gzip");
            connection.setRequestProperty("Content-type", "text/html");
            // keep-Alive，有什么用呢，你不是在访问网站，你是在采集。嘿嘿。减轻别人的压力，也是减轻自己。
            connection.setRequestProperty("Connection", "close");
            // 不要用cache，用了也没有什么用，因为我们不会经常对一个链接频繁访问。（针对程序）
            connection.setUseCaches(false);
            connection.setConnectTimeout(6 * 1000);
            connection.setReadTimeout(6 * 1000);
            connection.setDoOutput(true);
            connection.setDoInput(true);
            connection.setRequestProperty("Charset", "utf-8");

            connection.connect();

            if (200 == connection.getResponseCode()) {
                InputStream inputStream = null;
                if (connection.getContentEncoding() != null
                        && !connection.getContentEncoding().equals("")) {
                    String encode = connection.getContentEncoding()
                            .toLowerCase();
                    if (encode != null && !encode.equals("")
                            && encode.indexOf("gzip") >= 0) {
                        inputStream = new GZIPInputStream(
                                connection.getInputStream());
                    }
                }

                if (null == inputStream) {
                    inputStream = connection.getInputStream();
                }

                BufferedReader reader = new BufferedReader(
                        new InputStreamReader(inputStream, "utf-8"));
                StringBuilder builder = new StringBuilder();
                String line = null;
                while ((line = reader.readLine()) != null) {
                    builder.append(line).append("\n");
                }
                content = builder.toString();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }

        return content;
    }

    private static void getOneTermContent(String pageContent) {
//        String regex = "<td align=\"center\" style=\"padding-left:10px;\">[\\s\\S]+?</em></td>";
        String regex = "<td align=\"center\">([\\S]+?)</td>[\\s]+?<td align=\"center\">([\\S]+?)</td>[\\s]+?<td align=\"center\" style=\"padding-left:10px;\">([\\s\\S]+?)</em></td>";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(pageContent);
        while (matcher.find()) {
//            System.out.println("开奖日期:" + matcher.group(1));
//            System.out.println("期号:" + matcher.group(2));
            String oneTermContent = matcher.group(3);
            getOneTermNumbers(matcher.group(1),matcher.group(2),oneTermContent);
        }
    }

    private static void getOneTermNumbers(String kjri,String qh,String oneTermContent) {

        String regex = ">\\d+<";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(oneTermContent);
        StringBuffer ballNumber_=new StringBuffer();;
        while (matcher.find()) {
            String content = matcher.group();
            String ballNumber = content.substring(1, content.length() - 1);
            ballNumber_.append(ballNumber).append(" ");
            mStringBuffer.append(ballNumber).append(" ");
        }
        System.out.println("开奖日期:"+kjri +" 期号:"+qh+" :中奖号码:" +ballNumber_.toString());
        mStringBuffer.append("\r\n");
    }
}
