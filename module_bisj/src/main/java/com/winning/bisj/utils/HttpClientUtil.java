package com.winning.bisj.utils;


import com.alibaba.fastjson.JSONArray;
import org.apache.http.HttpEntity;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class HttpClientUtil {

    protected static final Logger LOGGER = LoggerFactory.getLogger(HttpClientUtil.class);

	public static String Post(String urlstr,String inParam ) {
		System.out.println("服务地址="+urlstr);
		System.out.println("参数="+inParam);
		try {
			URL url = new URL(urlstr);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			// 在连接之前设置属性

			// Content-Type实体头用于向接收方指示实体的介质类型，指定HEAD方法送到接收方的实体介质类型，或GET方法发送的请求介质类型
			conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
			// 设置打开与此URLConnection引用的资源的通信链接时使用的指定超时值（以毫秒为单位）
			conn.setConnectTimeout(10000);
			// 将读取超时设置为指定的超时时间，以毫秒为单位。
			// conn.setReadTimeout(60000);
			// 发送POST请求必须设置如下两行
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setRequestMethod("POST");
			// Post 请求不能使用缓存
			conn.setUseCaches(false);
			// 建立连接

			conn.connect();
			// 传入参数
			DataOutputStream dos = new DataOutputStream(conn.getOutputStream());
			dos.writeBytes(inParam);

			// 关闭流
			dos.flush();
			dos.close();
			// 获取响应
			BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line;
			String result = "";
			while ((line = reader.readLine()) != null) {
				result += line;
			}
			reader.close();
			conn.disconnect();
			return result;
		} catch (MalformedURLException e) {

			LOGGER.error(e.getMessage());
		} catch (SocketTimeoutException e) {
			LOGGER.error(e.getMessage());
		} catch (IOException e) {

			LOGGER.error(e.getMessage());
		}

		return null;
	}

	public static String Get(String realUrl) {
		try {

			// 传入参数
			URL url = new URL(realUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			// 在连接之前设置属性
			// Content-Type实体头用于向接收方指示实体的介质类型，指定HEAD方法送到接收方的实体介质类型，或GET方法发送的请求介质类型
			conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
			// 设置打开与此URLConnection引用的资源的通信链接时使用的指定超时值（以毫秒为单位）
			conn.setConnectTimeout(10000);
			// 将读取超时设置为指定的超时时间，以毫秒为单位。
			// conn.setReadTimeout(60000);
			conn.setRequestMethod("GET");
			// Post 请求不能使用缓存
			conn.setUseCaches(false);
			// 建立连接
			conn.connect();
			// 获取响应
			BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line;
			String result = "";
			while ((line = reader.readLine()) != null) {
				result += line;
			}
			reader.close();
			conn.disconnect();
			return result;
		} catch (MalformedURLException e) {

			LOGGER.error(e.getMessage());
		} catch (SocketTimeoutException e) {
			LOGGER.error(e.getMessage());
		} catch (IOException e) {

			LOGGER.error(e.getMessage());
		}
		return null;
	}

	public static String doPost(String url, JSONArray jsonArray) {
		CloseableHttpClient closeableHttpClient = HttpClients.createDefault();
		//配置连接超时时间
		RequestConfig requestConfig = RequestConfig.custom()
				.setConnectTimeout(5000)
				.setConnectionRequestTimeout(5000)
				.setSocketTimeout(5000)
				.setRedirectsEnabled(true)
				.build();
		HttpPost httpPost = new HttpPost(url);
		//设置超时时间
		httpPost.setConfig(requestConfig);
		//装配post请求参数

		try {
			//将参数进行编码为合适的格式
			StringEntity s = new StringEntity(jsonArray.toString());
			s.setContentEncoding("UTF-8");
			s.setContentType("application/json");
			httpPost.setEntity(s);
			//执行 post请求
			CloseableHttpResponse closeableHttpResponse = closeableHttpClient.execute(httpPost);
			String strRequest = "";
			if (closeableHttpResponse!=null) {

				if (closeableHttpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
					HttpEntity httpEntity = closeableHttpResponse.getEntity();
					strRequest = EntityUtils.toString(httpEntity);
				} else {
					strRequest = "Error Response" + closeableHttpResponse.getStatusLine().getStatusCode();
				}
			}
			return strRequest;

		} catch (ClientProtocolException e) {
			LOGGER.error(e.getMessage());
			return "协议异常";
		} catch (ParseException e) {
			LOGGER.error(e.getMessage());
			return "解析异常";
		} catch (IOException e) {
			LOGGER.error(e.getMessage());
			return "传输异常";
		} finally {
			try {
				if (closeableHttpClient != null) {
					closeableHttpClient.close();
				}
			} catch (IOException e) {
				LOGGER.error(e.getMessage());
			}

		}
	}

}
